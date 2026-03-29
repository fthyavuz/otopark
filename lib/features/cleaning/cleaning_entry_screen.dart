import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../database/database.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/settings_provider.dart';
import '../../shared/utils/plate_input_formatter.dart';
import '../../shared/utils/plate_validator.dart';
import 'cleaning_models.dart';

class CleaningEntryScreen extends ConsumerStatefulWidget {
  const CleaningEntryScreen({super.key});

  @override
  ConsumerState<CleaningEntryScreen> createState() => _CleaningEntryScreenState();
}

class _CleaningEntryScreenState extends ConsumerState<CleaningEntryScreen> {
  final _plateCtrl = TextEditingController();
  final _focusNode = FocusNode();

  List<String> _suggestions = [];
  bool _lookupLoading = false;

  // Resolved state
  bool _isLargeVehicle = false;
  bool _wasParkingCar = false;
  String? _subscriberType; // null, 'daily', 'monthly'
  bool _plateReady = false; // true once plate is long enough to proceed

  @override
  void dispose() {
    _plateCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onPlateChanged(String raw) async {
    final plate = PlateValidator.normalise(raw);
    setState(() {
      _isLargeVehicle = false;
      _wasParkingCar = false;
      _subscriberType = null;
      _plateReady = false;
      _lookupLoading = plate.length >= 4;
    });
    if (plate.length < 2) {
      setState(() => _suggestions = []);
      return;
    }

    final db = ref.read(databaseProvider);
    final suggested = await db.searchRegisteredVehiclePlates(plate, limit: 8);
    if (!mounted) return;
    setState(() => _suggestions = suggested.where((s) => s != plate).toList());

    if (plate.length < 4) {
      setState(() => _lookupLoading = false);
      return;
    }

    final results = await Future.wait([
      db.getRegisteredVehicle(plate),
      db.getRecordByPlate(plate),
      db.isKnownLargeVehicle(plate),
    ]);

    if (!mounted) return;
    final registered = results[0] as RegisteredVehicle?;
    final insideRecord = results[1] as ParkingRecord?;
    final knownLarge = results[2] as bool;

    bool isLarge = knownLarge || (registered?.vehicleType == 'large');
    bool isParkingCar = insideRecord != null;
    String? subType;

    if (isParkingCar) {
      if (insideRecord.isSubscriber) {
        subType = 'monthly';
      } else if (insideRecord.isDailySubscriber) {
        subType = 'daily';
      }
    } else if (registered != null) {
      if (registered.subscriptionType == 'monthly') subType = 'monthly';
      if (registered.subscriptionType == 'daily') subType = 'daily';
    }

    setState(() {
      _isLargeVehicle = isLarge;
      _wasParkingCar = isParkingCar;
      _subscriberType = subType;
      _plateReady = true;
      _lookupLoading = false;
    });
  }

  void _applySuggestion(String plate) {
    _plateCtrl.text = plate;
    setState(() => _suggestions = []);
    _focusNode.requestFocus();
    _onPlateChanged(plate);
  }

  Future<void> _proceed() async {
    final raw = _plateCtrl.text.trim();
    if (raw.isEmpty) return;
    final plate = PlateValidator.normalise(raw);

    if (!PlateValidator.isTurkishPlate(plate)) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.warning_amber, color: Colors.orange, size: 40),
          title: const Text('Türk Plakası Değil'),
          content: Text('"$plate" Türk plaka formatına uymuyor. Devam edilsin mi?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('İptal')),
            FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Devam Et')),
          ],
        ),
      );
      if (proceed != true || !mounted) return;
    }

    context.push(
      '/cleaning-service',
      extra: CleaningEntryData(
        plate: plate,
        isLargeVehicle: _isLargeVehicle,
        wasParkingCar: _wasParkingCar,
        subscriberType: _subscriberType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final companyName = ref.watch(cleaningSettingsProvider).companyName;
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(companyName),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Temizlik Listesi',
            onPressed: () => context.push('/cleaning-list'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isTablet ? 520 : double.infinity),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                                child: CircularProgressIndicator(strokeWidth: 2)),
                          )
                        : _plateCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _plateCtrl.clear();
                                  setState(() {
                                    _isLargeVehicle = false;
                                    _wasParkingCar = false;
                                    _subscriberType = null;
                                    _plateReady = false;
                                    _suggestions = [];
                                  });
                                },
                              )
                            : null,
                  ),
                  onChanged: _onPlateChanged,
                  onSubmitted: (_) => _proceed(),
                ),

                // ── Suggestions ────────────────────────────────
                if (_suggestions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _suggestions
                        .map((s) => ActionChip(
                              avatar: const Icon(Icons.directions_car, size: 16),
                              label: Text(s,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5)),
                              onPressed: () => _applySuggestion(s),
                            ))
                        .toList(),
                  ),
                ],

                // ── Vehicle info card ──────────────────────────
                if (_plateReady && !_lookupLoading) ...[
                  const SizedBox(height: 20),
                  _VehicleInfoCard(
                    plate: PlateValidator.normalise(_plateCtrl.text),
                    isLargeVehicle: _isLargeVehicle,
                    wasParkingCar: _wasParkingCar,
                    subscriberType: _subscriberType,
                  ),
                ],

                const SizedBox(height: 24),

                // ── Proceed button ─────────────────────────────
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: (_lookupLoading ||
                            PlateValidator.normalise(_plateCtrl.text).length < 2)
                        ? null
                        : _proceed,
                    icon: const Icon(Icons.local_car_wash),
                    label: const Text('Hizmet Seç',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VehicleInfoCard extends StatelessWidget {
  const _VehicleInfoCard({
    required this.plate,
    required this.isLargeVehicle,
    required this.wasParkingCar,
    required this.subscriberType,
  });

  final String plate;
  final bool isLargeVehicle;
  final bool wasParkingCar;
  final String? subscriberType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.teal.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isLargeVehicle ? Icons.local_shipping : Icons.directions_car,
                color: isLargeVehicle ? Colors.orange : Colors.teal,
              ),
              const SizedBox(width: 8),
              Text(plate,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2)),
              const Spacer(),
              if (isLargeVehicle)
                _chip('BÜYÜK ARAÇ', Colors.orange.shade100, Colors.orange.shade800),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (wasParkingCar)
                _chip('OTOPARK İÇİNDE', Colors.blue.shade100, Colors.blue.shade800),
              if (subscriberType == 'monthly')
                _chip('AYLIK ABONE', Colors.green.shade100, Colors.green.shade800),
              if (subscriberType == 'daily')
                _chip('GÜNLÜK ABONE', Colors.teal.shade100, Colors.teal.shade800),
              if (!wasParkingCar && subscriberType == null)
                _chip('Dışarıdan Gelen', Colors.grey.shade200, Colors.grey.shade700),
            ],
          ),
        ],
      ),
    );
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
