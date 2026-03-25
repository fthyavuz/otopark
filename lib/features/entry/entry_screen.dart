import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../database/database.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/utils/currency_formatter.dart';
import '../../shared/utils/plate_input_formatter.dart';
import '../../shared/utils/plate_validator.dart';
import '../tariff/tariff_providers.dart';
import 'entry_models.dart';

class EntryScreen extends ConsumerStatefulWidget {
  const EntryScreen({super.key});

  @override
  ConsumerState<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends ConsumerState<EntryScreen> {
  final _plateCtrl = TextEditingController();
  final _focusNode = FocusNode();

  bool _saving = false;
  List<String> _suggestions = [];
  Set<String> _registeredSuggestions = {}; // plates that come from registered vehicles

  // Lookup result — set after plate is entered
  VehicleLookupResult? _lookupResult;
  bool _lookupLoading = false;

  // Registration form state (for new vehicles)
  String _newVehicleType = 'normal'; // 'normal' | 'large'
  String _newSubscriptionType = 'none'; // 'none' | 'daily' | 'monthly'

  @override
  void dispose() {
    _plateCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ─── Plate change ─────────────────────────────────────────────────────────

  Future<void> _onPlateChanged(String raw) async {
    setState(() {
      _lookupResult = null;
      _lookupLoading = false;
      _suggestions = [];
      _registeredSuggestions = {};
    });

    final plate = PlateValidator.normalise(raw);
    if (plate.length < 2) return;

    final db = ref.read(databaseProvider);

    // ── Suggestions from registered vehicles (2+ chars, suffix-friendly) ──
    final suggestionsFromRegistered =
        await db.searchRegisteredVehiclePlates(plate, limit: 8);

    if (!mounted) return;
    final currentNorm = PlateValidator.normalise(_plateCtrl.text);
    final regSet = suggestionsFromRegistered.where((s) => s != currentNorm).toSet();
    setState(() {
      _suggestions = regSet.toList();
      _registeredSuggestions = regSet;
    });

    // ── Full lookup only when plate is long enough to be meaningful ────────
    if (plate.length < 4) return;

    setState(() => _lookupLoading = true);

    final results = await Future.wait([
      db.searchDistinctPlates(plate),
      db.getRegisteredVehicle(plate),
      db.getRecordByPlate(plate),
    ]);

    if (!mounted) return;

    final registered = results[1] as RegisteredVehicle?;
    final insideRecord = results[2] as ParkingRecord?;
    final currentNorm2 = PlateValidator.normalise(_plateCtrl.text);

    setState(() {
      // Merge: registered vehicles first, then parking history (no duplicates)
      final fromHistory = (results[0] as List<String>)
          .where((s) => s != currentNorm2)
          .toSet();
      final fromRegistered = suggestionsFromRegistered
          .where((s) => s != currentNorm2)
          .toSet();
      _registeredSuggestions = fromRegistered;
      _suggestions = {...fromRegistered, ...fromHistory}.toList();

      _lookupResult = VehicleLookupResult(
        registered: registered,
        isInsideAlready: insideRecord != null,
      );
      _lookupLoading = false;

      if (registered != null) {
        _newVehicleType = registered.vehicleType;
        _newSubscriptionType = registered.subscriptionType;
      } else {
        _newVehicleType = 'normal';
        _newSubscriptionType = 'none';
      }
    });
  }

  void _applySuggestion(String plate) {
    _plateCtrl.text = plate;
    setState(() {
      _suggestions = [];
      _registeredSuggestions = {};
    });
    _focusNode.requestFocus();
    _onPlateChanged(plate);
  }

  // ─── Submit ───────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    final rawPlate = _plateCtrl.text.trim();
    if (rawPlate.isEmpty) {
      _showError('Plaka numarası boş olamaz.');
      return;
    }

    final plate = PlateValidator.normalise(rawPlate);

    if (!PlateValidator.isTurkishPlate(plate)) {
      final proceed = await _showForeignPlateDialog(plate);
      if (!proceed) return;
    }

    final db = ref.read(databaseProvider);

    // Block if already inside
    final existing = await db.getRecordByPlate(plate);
    if (existing != null) {
      _showError('$plate plakası şu anda otopark içinde!');
      return;
    }

    final lookup = _lookupResult;

    // ── KNOWN VEHICLE ──────────────────────────────────────────────────────
    if (lookup != null && !lookup.isNewVehicle) {
      final reg = lookup.registered!;

      if (lookup.isMonthlySubscriber) {
        // Valid monthly subscriber — let in for free
        await _saveEntry(
          plate: plate,
          isMonthlySubscriber: true,
          isLargeVehicle: lookup.isLargeVehicle,
          isDailySubscriber: false,
        );
        return;
      }

      if (lookup.isMonthlyExpired) {
        // Monthly but expired — offer renewal
        final tariff = await db.getActiveTariff();
        final fee = tariff?.monthlyPrice ?? reg.monthlyFee;
        if (!mounted) return;
        context.push(
          '/subscription-payment',
          extra: SubscriptionPaymentData(
            plate: plate,
            vehicleType: reg.vehicleType,
            amount: fee,
            isRenewal: true,
          ),
        );
        return;
      }

      if (lookup.isDailySubscriber) {
        await _saveEntry(
          plate: plate,
          isMonthlySubscriber: false,
          isDailySubscriber: true,
          isLargeVehicle: lookup.isLargeVehicle,
        );
        return;
      }

      // 'none' subscription
      await _saveEntry(
        plate: plate,
        isMonthlySubscriber: false,
        isDailySubscriber: false,
        isLargeVehicle: lookup.isLargeVehicle,
      );
      return;
    }

    // ── NEW VEHICLE — registration ─────────────────────────────────────────
    if (_newSubscriptionType == 'monthly') {
      // Navigate to subscription payment screen
      final tariff = await db.getActiveTariff();
      final fee = tariff?.monthlyPrice ?? 4000.0;
      if (!mounted) return;
      context.push(
        '/subscription-payment',
        extra: SubscriptionPaymentData(
          plate: plate,
          vehicleType: _newVehicleType,
          amount: fee,
          isRenewal: false,
        ),
      );
      return;
    }

    // Save registration record for non-monthly
    await db.upsertRegisteredVehicle(RegisteredVehiclesCompanion(
      plate: Value(plate),
      vehicleType: Value(_newVehicleType),
      subscriptionType: Value(_newSubscriptionType),
      createdAt: Value(DateTime.now()),
    ));

    // Also persist large vehicle to legacy table for exit-flow compat
    if (_newVehicleType == 'large') {
      await db.addKnownLargeVehicle(plate);
    }

    await _saveEntry(
      plate: plate,
      isMonthlySubscriber: false,
      isDailySubscriber: _newSubscriptionType == 'daily',
      isLargeVehicle: _newVehicleType == 'large',
    );
  }

  Future<void> _saveEntry({
    required String plate,
    required bool isMonthlySubscriber,
    required bool isDailySubscriber,
    required bool isLargeVehicle,
  }) async {
    final db = ref.read(databaseProvider);
    final tariff = await db.getActiveTariff();

    setState(() => _saving = true);
    try {
      await db.insertParkingRecord(ParkingRecordsCompanion.insert(
        plate: plate,
        entryTime: DateTime.now(),
        isSubscriber: Value(isMonthlySubscriber),
        isDailySubscriber: Value(isDailySubscriber),
        isLargeVehicle: Value(isLargeVehicle),
        tariffId: Value(tariff?.id),
        status: const Value('inside'),
      ));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('$plate girişi kaydedildi.'),
          ]),
          backgroundColor: Colors.green,
        ));
        _plateCtrl.clear();
        setState(() {
          _lookupResult = null;
          _suggestions = [];
          _newVehicleType = 'normal';
          _newSubscriptionType = 'none';
        });
        _focusNode.requestFocus();
      }
    } catch (e) {
      _showError('Kayıt sırasında hata oluştu: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<bool> _showForeignPlateDialog(String plate) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.warning_amber,
                color: Colors.orange, size: 40),
            title: const Text('Türk Plakası Değil'),
            content: Text(
              '"$plate" Türk plaka formatına uymuyor.\nYabancı araç olabilir. Yine de devam edilsin mi?',
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('İptal')),
              FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Devam Et')),
            ],
          ),
        ) ??
        false;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final activeTariffAsync = ref.watch(activeTariffProvider);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final lookup = _lookupResult;

    return Scaffold(
      appBar: AppBar(title: const Text('Araç Girişi')),
      body: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: isTablet ? 520 : double.infinity),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── No tariff warning ──────────────────────────
                activeTariffAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (tariff) => tariff == null
                      ? _warningBanner(
                          'Aktif tarife yok. Ücret hesaplanamaz.',
                          () => context.push('/tariff'),
                          'Tarife Ekle',
                          context,
                        )
                      : const SizedBox.shrink(),
                ),

                // ── Plate input ────────────────────────────────
                Text('Plaka Numarası',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: _plateCtrl,
                  focusNode: _focusNode,
                  autofocus: true,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: const [PlateInputFormatter()],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                  decoration: InputDecoration(
                    hintText: '34 ABC 1234',
                    hintStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2,
                        color: Colors.grey),
                    suffixIcon: _lookupLoading
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2)),
                          )
                        : _plateCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _plateCtrl.clear();
                                  setState(() {
                                    _lookupResult = null;
                                    _suggestions = [];
                                    _newVehicleType = 'normal';
                                    _newSubscriptionType = 'none';
                                  });
                                },
                              )
                            : null,
                  ),
                  onChanged: _onPlateChanged,
                  onSubmitted: (_) => _submit(),
                ),

                // ── Suggestions ────────────────────────────────
                if (_suggestions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _suggestions.map((s) {
                      final isRegistered = _registeredSuggestions.contains(s);
                      return ActionChip(
                        avatar: Icon(
                          isRegistered
                              ? Icons.directions_car
                              : Icons.history,
                          size: 16,
                          color: isRegistered ? Colors.indigo : null,
                        ),
                        label: Text(s,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5)),
                        onPressed: () => _applySuggestion(s),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 20),

                // ── Vehicle info ───────────────────────────────
                if (lookup != null) ...[
                  if (lookup.isInsideAlready)
                    _warningBanner(
                      '${PlateValidator.normalise(_plateCtrl.text)} plakası şu anda otopark içinde!',
                      null, null, context)
                  else if (!lookup.isNewVehicle)
                    _KnownVehicleCard(
                      lookup: lookup,
                      activeTariff: activeTariffAsync.value,
                    )
                  else
                    _NewVehicleForm(
                      vehicleType: _newVehicleType,
                      subscriptionType: _newSubscriptionType,
                      activeTariff: activeTariffAsync.value,
                      onVehicleTypeChanged: (v) =>
                          setState(() => _newVehicleType = v),
                      onSubscriptionTypeChanged: (v) =>
                          setState(() => _newSubscriptionType = v),
                    ),
                  const SizedBox(height: 20),
                ],

                // ── Submit ──────────────────────────────────────
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: (lookup?.isInsideAlready == true || _saving)
                        ? null
                        : _submit,
                    icon: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.login),
                    label: Text(
                      lookup != null && !lookup.isNewVehicle
                          ? 'Girişi Kaydet'
                          : 'Kaydet ve Giriş Yap',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _warningBanner(
      String message, VoidCallback? action, String? actionLabel,
      BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
          if (action != null && actionLabel != null)
            TextButton(
                onPressed: action, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

// ─── Known vehicle card ───────────────────────────────────────────────────────

class _KnownVehicleCard extends StatelessWidget {
  const _KnownVehicleCard({
    required this.lookup,
    required this.activeTariff,
  });

  final VehicleLookupResult lookup;
  final Tariff? activeTariff;

  @override
  Widget build(BuildContext context) {
    final reg = lookup.registered!;
    final isLarge = reg.vehicleType == 'large';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isLarge ? Icons.local_shipping : Icons.directions_car,
                  color: isLarge ? Colors.orange : Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'Kayıtlı Araç',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                    fontSize: 16),
              ),
              const Spacer(),
              if (isLarge)
                _chip('BÜYÜK ARAÇ', Colors.orange.shade100,
                    Colors.orange.shade800),
            ],
          ),
          const SizedBox(height: 10),
          _subInfo(context, reg),
          const SizedBox(height: 6),
          Text(
            'Araç bilgilerini değiştirmek için yönetici panelini kullanın.',
            style: TextStyle(
                fontSize: 11,
                color: Colors.blue.shade400,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _subInfo(BuildContext context, RegisteredVehicle reg) {
    if (reg.subscriptionType == 'monthly') {
      if (lookup.isMonthlySubscriber) {
        final days = reg.subscriptionEndDate!
            .difference(DateTime.now())
            .inDays
            .clamp(0, 9999);
        final endStr =
            DateFormat('dd.MM.yyyy').format(reg.subscriptionEndDate!);
        return Row(children: [
          _chip('AYLIK ABONMAN', Colors.green.shade100,
              Colors.green.shade800),
          const SizedBox(width: 8),
          Text('$endStr ($days gün kaldı)',
              style: TextStyle(
                  fontSize: 12, color: Colors.green.shade700)),
        ]);
      } else {
        return Row(children: [
          _chip('ABONELİK SÜRESI DOLMUŞ', Colors.red.shade100,
              Colors.red.shade800),
          const SizedBox(width: 8),
          Text(
            'Yenilemek için ödeme ekranı açılacak',
            style: TextStyle(fontSize: 11, color: Colors.red.shade600),
          ),
        ]);
      }
    }
    if (reg.subscriptionType == 'daily') {
      return _chip(
          'GÜNLÜK ABONE', Colors.teal.shade100, Colors.teal.shade800);
    }
    return _chip(
        'ABONELİK YOK', Colors.grey.shade200, Colors.grey.shade700);
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: fg)),
    );
  }
}

// ─── New vehicle registration form ───────────────────────────────────────────

class _NewVehicleForm extends StatelessWidget {
  const _NewVehicleForm({
    required this.vehicleType,
    required this.subscriptionType,
    required this.activeTariff,
    required this.onVehicleTypeChanged,
    required this.onSubscriptionTypeChanged,
  });

  final String vehicleType;
  final String subscriptionType;
  final Tariff? activeTariff;
  final ValueChanged<String> onVehicleTypeChanged;
  final ValueChanged<String> onSubscriptionTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.purple.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.app_registration, color: Colors.purple.shade700),
              const SizedBox(width: 8),
              Text(
                'İlk Giriş — Araç Kaydı',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade800,
                    fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Vehicle type
          Text('Araç Türü',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                  value: 'normal',
                  label: Text('Normal Araç'),
                  icon: Icon(Icons.directions_car)),
              ButtonSegment(
                  value: 'large',
                  label: Text('Büyük Araç'),
                  icon: Icon(Icons.local_shipping)),
            ],
            selected: {vehicleType},
            onSelectionChanged: (s) => onVehicleTypeChanged(s.first),
            style: const ButtonStyle(
                visualDensity: VisualDensity.compact),
          ),

          const SizedBox(height: 16),

          // Subscription type
          Text('Abonelik',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                  value: 'none',
                  label: Text('Yok'),
                  icon: Icon(Icons.block)),
              ButtonSegment(
                  value: 'daily',
                  label: Text('Günlük'),
                  icon: Icon(Icons.today)),
              ButtonSegment(
                  value: 'monthly',
                  label: Text('Aylık'),
                  icon: Icon(Icons.calendar_month)),
            ],
            selected: {subscriptionType},
            onSelectionChanged: (s) => onSubscriptionTypeChanged(s.first),
            style: const ButtonStyle(
                visualDensity: VisualDensity.compact),
          ),

          // Info boxes
          if (subscriptionType == 'monthly') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 16, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ödeme ekranı açılacak. '
                      '${activeTariff != null ? CurrencyFormatter.format(activeTariff!.monthlyPrice) : ""} '
                      'tahsil edildikten sonra 30 günlük abonelik başlayacak.',
                      style: TextStyle(
                          fontSize: 12, color: Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (subscriptionType == 'daily') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 16, color: Colors.teal.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Her gün için bir kez ücret alınır, gün içi giriş/çıkış ücretsizdir.',
                    style:
                        TextStyle(fontSize: 12, color: Colors.teal.shade700),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
