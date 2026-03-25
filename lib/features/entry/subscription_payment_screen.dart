import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../database/database.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/settings_provider.dart';
import '../../shared/utils/currency_formatter.dart';
import 'entry_models.dart';

class SubscriptionPaymentScreen extends ConsumerStatefulWidget {
  const SubscriptionPaymentScreen({super.key, required this.data});

  final SubscriptionPaymentData data;

  @override
  ConsumerState<SubscriptionPaymentScreen> createState() =>
      _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState
    extends ConsumerState<SubscriptionPaymentScreen> {
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

    try {
      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 30));

      // Save / update registered vehicle
      await db.upsertRegisteredVehicle(RegisteredVehiclesCompanion(
        plate: Value(d.plate.toUpperCase()),
        vehicleType: Value(d.vehicleType),
        subscriptionType: const Value('monthly'),
        subscriptionStartDate: Value(now),
        subscriptionEndDate: Value(endDate),
        monthlyFee: Value(d.amount),
        createdAt: Value(now),
      ));

      // Create revenue record so this payment appears in reports
      await db.insertSubscriptionPaymentRecord(
        plate: d.plate,
        amount: d.amount,
        notes: d.isRenewal ? 'Aylık Abonman Yenileme' : 'Aylık Abonman Ödemesi',
      );

      // Create parking entry record
      final tariff = await db.getActiveTariff();
      await db.insertParkingRecord(ParkingRecordsCompanion.insert(
        plate: d.plate.toUpperCase(),
        entryTime: now,
        isSubscriber: const Value(true),
        isDailySubscriber: const Value(false),
        isLargeVehicle: Value(d.vehicleType == 'large'),
        tariffId: Value(tariff?.id),
        status: const Value('inside'),
      ));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('${d.plate} girişi ve abonman ödemesi kaydedildi.'),
          ]),
          backgroundColor: Colors.green,
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
    final lotName = ref.watch(lotNameProvider);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final plateFontSize = isTablet ? 64.0 : 44.0;
    final costFontSize = isTablet ? 96.0 : 72.0;
    final labelFontSize = isTablet ? 20.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        if (lotName.isNotEmpty)
                          Text(lotName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: labelFontSize,
                                  fontWeight: FontWeight.bold)),
                        Text(
                          d.isRenewal
                              ? 'Abonman Yenileme'
                              : 'Yeni Abonman Kaydı',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: labelFontSize * 0.85),
                        ),
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
                    Text(
                      d.plate,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: plateFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'AYLIK ABONMAN ÖDEMESİ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: labelFontSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2),
                        ),
                      ),
                    ),
                    if (d.vehicleType == 'large') ...[
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
                    const SizedBox(height: 32),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 36 : 28, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade800,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.blue.shade800.withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            CurrencyFormatter.format(d.amount),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: costFontSize,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '30 günlük abonelik',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: labelFontSize,
                                color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Confirm button ────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 48 : 24, 0, isTablet ? 48 : 24, isTablet ? 32 : 24),
              child: SizedBox(
                height: isTablet ? 72 : 64,
                child: FilledButton.icon(
                  onPressed: _confirming ? null : _confirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: _confirming
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
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
