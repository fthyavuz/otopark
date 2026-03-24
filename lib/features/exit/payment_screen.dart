import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../shared/providers/database_provider.dart';
import '../../shared/utils/currency_formatter.dart';
import '../../shared/utils/duration_formatter.dart';
import 'exit_models.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.data});

  final PaymentData data;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _confirming = false;

  @override
  void initState() {
    super.initState();
    // Keep screen on while showing payment.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // ─── Confirm exit ─────────────────────────────────────────────────────────

  Future<void> _confirmExit() async {
    setState(() => _confirming = true);

    final db = ref.read(databaseProvider);
    final d = widget.data;

    try {
      await db.exitCar(
        recordId: d.record.id,
        exitTime: d.exitTime,
        calculatedCost: d.costResult.cost,
        tariffNameSnapshot: d.tariff.name,
        isSubscriber: d.costResult.isSubscriber,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('${d.record.plate} çıkışı kaydedildi.'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _confirming = false);
      }
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final isSubscriber = d.costResult.isSubscriber;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    // Adaptive font sizes
    final plateFontSize = isTablet ? 64.0 : 44.0;
    final costFontSize = isTablet ? 96.0 : 72.0;
    final labelFontSize = isTablet ? 20.0 : 16.0;
    final detailFontSize = isTablet ? 22.0 : 18.0;

    final entryStr = DateFormat('HH:mm').format(d.record.entryTime);
    final exitStr = DateFormat('HH:mm').format(d.exitTime);
    final entryDateStr = DateFormat('dd.MM.yyyy').format(d.record.entryTime);
    final isToday = _isToday(d.record.entryTime);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: back + tariff name ───────────────────
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
                    child: Text(
                      d.tariff.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white60, fontSize: labelFontSize),
                    ),
                  ),
                  const SizedBox(width: 48), // balance the back button
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
                    // ── Plate number ────────────────────────────
                    Text(
                      d.record.plate,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: plateFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 6,
                      ),
                    ),

                    if (isSubscriber) ...[
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'ABONMAN MÜŞTERİSİ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: labelFontSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // ── Cost box ────────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 36 : 28,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: isSubscriber
                            ? Colors.green.shade800
                            : const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (isSubscriber
                                    ? Colors.green
                                    : const Color(0xFF1565C0))
                                .withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            isSubscriber ? 'ÜCRETSİZ' : CurrencyFormatter.format(d.costResult.cost),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: costFontSize,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          if (!isSubscriber) ...[
                            const SizedBox(height: 4),
                            Text(
                              d.costResult.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: labelFontSize,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Detail rows ─────────────────────────────
                    _PaymentDetailRow(
                      label: 'Giriş',
                      value:
                          isToday ? entryStr : '$entryDateStr $entryStr',
                      fontSize: detailFontSize,
                    ),
                    const SizedBox(height: 6),
                    _PaymentDetailRow(
                      label: 'Çıkış',
                      value: exitStr,
                      fontSize: detailFontSize,
                    ),
                    const SizedBox(height: 6),
                    _PaymentDetailRow(
                      label: 'Süre',
                      value: DurationFormatter.format(
                          Duration(minutes: d.costResult.elapsedMinutes)),
                      fontSize: detailFontSize,
                    ),
                  ],
                ),
              ),
            ),

            // ── Confirm button ──────────────────────────────────
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
                  onPressed: _confirming ? null : _confirmExit,
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

  static bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }
}

// ─── Detail row ───────────────────────────────────────────────────────────────

class _PaymentDetailRow extends StatelessWidget {
  const _PaymentDetailRow({
    required this.label,
    required this.value,
    required this.fontSize,
  });

  final String label;
  final String value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: fontSize, color: Colors.white60)),
        Text(value,
            style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
