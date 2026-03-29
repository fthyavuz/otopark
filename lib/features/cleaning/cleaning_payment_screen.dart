import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../database/database.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/settings_provider.dart';
import '../../shared/utils/currency_formatter.dart';
import 'cleaning_models.dart';

class CleaningPaymentScreen extends ConsumerStatefulWidget {
  const CleaningPaymentScreen({super.key, required this.data});

  final CleaningPaymentData data;

  @override
  ConsumerState<CleaningPaymentScreen> createState() =>
      _CleaningPaymentScreenState();
}

class _CleaningPaymentScreenState
    extends ConsumerState<CleaningPaymentScreen> {
  bool _confirming = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _confirm() async {
    setState(() => _confirming = true);
    final db = ref.read(databaseProvider);
    final d = widget.data;
    final now = DateTime.now();

    try {
      await db.insertCleaningRecord(CleaningRecordsCompanion.insert(
        plate: d.plate.toUpperCase(),
        serviceType: d.serviceType.value,
        baseCost: d.baseCost,
        finalCost: d.finalCost,
        discountPercent: Value(d.discountPercent),
        isLargeVehicle: Value(d.isLargeVehicle),
        wasParkingCar: Value(d.wasParkingCar),
        notes: Value(d.notes),
        status: const Value('cleaned'),
        createdAt: now,
        completedAt: Value(now),
      ));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(
                '${d.plate} – ${d.serviceType.displayName} tamamlandı.'),
          ]),
          backgroundColor: Colors.teal,
        ));
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: Colors.red,
        ));
        setState(() => _confirming = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final settings = ref.watch(cleaningSettingsProvider);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final plateFontSize = isTablet ? 64.0 : 44.0;
    final costFontSize = isTablet ? 96.0 : 72.0;
    final labelFontSize = isTablet ? 20.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0D2018),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white60),
                    onPressed: () => context.pop(),
                    tooltip: 'Geri',
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(settings.companyName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: labelFontSize,
                                fontWeight: FontWeight.bold)),
                        Text('Ödeme',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: labelFontSize * 0.85)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 48.0 : 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(d.plate,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: plateFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 6,
                        )),
                    const SizedBox(height: 8),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(d.serviceType.displayName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: labelFontSize,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                      ),
                    ),
                    if (d.isLargeVehicle) ...[
                      const SizedBox(height: 6),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade700,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('BÜYÜK ARAÇ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: labelFontSize * 0.85,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                    if (d.discountPercent > 0) ...[
                      const SizedBox(height: 6),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                              '%${d.discountPercent.toStringAsFixed(0)} İndirim Uygulandı',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: labelFontSize * 0.85,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 36 : 28, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade800,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.shade800.withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        CurrencyFormatter.format(d.finalCost),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: costFontSize,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Confirm button ────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 48 : 24,
                0,
                isTablet ? 48 : 24,
                isTablet ? 32 : 24,
              ),
              child: SizedBox(
                height: isTablet ? 72 : 64,
                child: FilledButton.icon(
                  onPressed: _confirming ? null : _confirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: _confirming
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check_circle, size: 28),
                  label: Text(
                    'TAHSİL EDİLDİ',
                    style: TextStyle(
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
