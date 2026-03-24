import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../database/database.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/utils/cost_calculator.dart';
import '../../shared/utils/currency_formatter.dart';
import '../../shared/utils/duration_formatter.dart';
import '../../shared/utils/plate_validator.dart';
import '../active_cars/active_cars_providers.dart';
import 'exit_models.dart';

class ExitScreen extends ConsumerStatefulWidget {
  const ExitScreen({super.key, this.prefilledPlate});

  final String? prefilledPlate;

  @override
  ConsumerState<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends ConsumerState<ExitScreen> {
  late final TextEditingController _plateCtrl;
  String _searchQuery = '';

  ParkingRecord? _foundRecord;
  Tariff? _foundTariff;
  CostCalculationResult? _costResult;
  bool _loadingCost = false;
  String? _notFoundMsg;

  @override
  void initState() {
    super.initState();
    _plateCtrl = TextEditingController(text: widget.prefilledPlate ?? '');
    if (widget.prefilledPlate != null) {
      _searchQuery = PlateValidator.normalise(widget.prefilledPlate!);
      // Trigger lookup after first frame when providers are ready.
      WidgetsBinding.instance.addPostFrameCallback((_) => _lookup(_searchQuery));
    }
  }

  @override
  void dispose() {
    _plateCtrl.dispose();
    super.dispose();
  }

  // ─── Lookup ───────────────────────────────────────────────────────────────

  Future<void> _lookup(String plate) async {
    if (plate.length < 2) {
      setState(() {
        _foundRecord = null;
        _foundTariff = null;
        _costResult = null;
        _notFoundMsg = null;
      });
      return;
    }

    setState(() {
      _loadingCost = true;
      _foundRecord = null;
      _notFoundMsg = null;
    });

    final db = ref.read(databaseProvider);
    final record = await db.getRecordByPlate(plate);

    if (record == null) {
      setState(() {
        _loadingCost = false;
        _notFoundMsg = '"$plate" plakası şu anda otopark içinde değil.';
      });
      return;
    }

    // Load the tariff that was active at entry time.
    Tariff? tariff;
    if (record.tariffId != null) {
      tariff = await db.getTariffById(record.tariffId!);
    }
    tariff ??= await db.getActiveTariff();

    if (tariff == null) {
      setState(() {
        _loadingCost = false;
        _foundRecord = record;
        _notFoundMsg = 'Tarife bulunamadı. Lütfen önce tarife ekleyin.';
      });
      return;
    }

    final exitNow = DateTime.now();
    final subscriber = await db.findActiveSubscriberByPlate(record.plate);
    final cost = CostCalculator.calculate(
      entryTime: record.entryTime,
      exitTime: exitNow,
      tariff: tariff,
      isSubscriber: subscriber != null || record.isSubscriber,
    );

    setState(() {
      _loadingCost = false;
      _foundRecord = record;
      _foundTariff = tariff;
      _costResult = cost;
    });
  }

  // ─── Navigate to payment screen ───────────────────────────────────────────

  void _goToPayment() {
    if (_foundRecord == null || _foundTariff == null || _costResult == null) {
      return;
    }
    context.go(
      '/payment',
      extra: PaymentData(
        record: _foundRecord!,
        tariff: _foundTariff!,
        costResult: _costResult!,
        exitTime: DateTime.now(),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final carsAsync = ref.watch(insideCarsProvider);
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Araç Çıkışı')),
      body: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: isTablet ? 560 : double.infinity),
          child: Column(
            children: [
              // ── Search bar ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _plateCtrl,
                  autofocus: widget.prefilledPlate == null,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Plaka Numarası',
                    hintText: '34 ABC 1234',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _plateCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _plateCtrl.clear();
                              setState(() {
                                _searchQuery = '';
                                _foundRecord = null;
                                _foundTariff = null;
                                _costResult = null;
                                _notFoundMsg = null;
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (v) {
                    final q = PlateValidator.normalise(v);
                    setState(() => _searchQuery = q);
                    _lookup(q);
                  },
                  onSubmitted: (v) => _lookup(PlateValidator.normalise(v)),
                ),
              ),

              // ── Quick-pick from inside cars ───────────────────
              if (_foundRecord == null && _searchQuery.isEmpty)
                Expanded(
                  child: carsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Hata: $e')),
                    data: (cars) {
                      if (cars.isEmpty) {
                        return const Center(
                          child: Text('Otopark boş.',
                              style: TextStyle(color: Colors.grey)),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16, 8, 16, 4),
                            child: Text(
                              'İçerideki araçlardan seçin:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              itemCount: cars.length,
                              itemBuilder: (_, i) {
                                final c = cars[i];
                                final elapsed = DateTime.now()
                                    .difference(c.entryTime);
                                return Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.directions_car),
                                    title: Text(c.plate,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            letterSpacing: 2)),
                                    subtitle: Text(
                                        DurationFormatter.format(elapsed)),
                                    trailing: c.isSubscriber
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text('ABONMAN',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.green
                                                        .shade800,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                        : null,
                                    onTap: () {
                                      _plateCtrl.text = c.plate;
                                      final q =
                                          PlateValidator.normalise(c.plate);
                                      setState(() => _searchQuery = q);
                                      _lookup(q);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

              // ── Loading indicator ────────────────────────────
              if (_loadingCost)
                const Expanded(
                    child: Center(child: CircularProgressIndicator())),

              // ── Not found message ────────────────────────────
              if (!_loadingCost && _notFoundMsg != null && _foundRecord == null)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off,
                              size: 60, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(_notFoundMsg!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Cost summary card ─────────────────────────────
              if (!_loadingCost &&
                  _foundRecord != null &&
                  _costResult != null &&
                  _foundTariff != null)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _CostSummaryCard(
                      record: _foundRecord!,
                      tariff: _foundTariff!,
                      costResult: _costResult!,
                      onShowPayment: _goToPayment,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Cost summary card ────────────────────────────────────────────────────────

class _CostSummaryCard extends StatelessWidget {
  const _CostSummaryCard({
    required this.record,
    required this.tariff,
    required this.costResult,
    required this.onShowPayment,
  });

  final ParkingRecord record;
  final Tariff tariff;
  final CostCalculationResult costResult;
  final VoidCallback onShowPayment;

  @override
  Widget build(BuildContext context) {
    final exitNow = DateTime.now();
    final entryStr = DateFormat('HH:mm').format(record.entryTime);
    final exitStr = DateFormat('HH:mm').format(exitNow);
    final entryDateStr = DateFormat('dd.MM.yyyy').format(record.entryTime);
    final isToday = _isToday(record.entryTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Plate ──────────────────────────────────────────────
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Plate + subscriber badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      record.plate,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    if (costResult.isSubscriber) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('ABONMAN',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                // Times
                _DetailRow(
                    label: 'Giriş',
                    value: isToday ? entryStr : '$entryDateStr $entryStr'),
                _DetailRow(label: 'Çıkış', value: exitStr),
                _DetailRow(
                    label: 'Süre',
                    value: DurationFormatter.format(
                        Duration(minutes: costResult.elapsedMinutes))),

                const Divider(height: 20),

                // Cost
                _DetailRow(
                  label: 'Tarife',
                  value: tariff.name,
                  valueStyle: const TextStyle(color: Colors.grey),
                ),
                _DetailRow(
                  label: costResult.isSubscriber ? 'Ücret' : 'Uygulandı',
                  value: costResult.description,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TOPLAM',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                    Text(
                      costResult.isSubscriber
                          ? 'ÜCRETSİZ'
                          : CurrencyFormatter.format(costResult.cost),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: costResult.isSubscriber
                            ? Colors.green.shade700
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ── Payment button ──────────────────────────────────────
        SizedBox(
          height: 60,
          child: FilledButton.icon(
            onPressed: onShowPayment,
            icon: const Icon(Icons.payment, size: 24),
            label: const Text(
              'Ödeme Ekranını Göster',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  static bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey.shade700)),
          Text(value,
              style: valueStyle ??
                  Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
