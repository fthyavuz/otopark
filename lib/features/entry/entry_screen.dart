import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../database/database.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/utils/plate_validator.dart';
import '../tariff/tariff_providers.dart';

class EntryScreen extends ConsumerStatefulWidget {
  const EntryScreen({super.key});

  @override
  ConsumerState<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends ConsumerState<EntryScreen> {
  final _plateCtrl = TextEditingController();
  final _focusNode = FocusNode();

  bool _saving = false;
  Subscriber? _detectedSubscriber;
  bool _subscriberChecked = false;

  @override
  void dispose() {
    _plateCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ─── Subscriber auto-detect ───────────────────────────────────────────────

  Future<void> _checkSubscriber(String plate) async {
    if (plate.length < 4) {
      setState(() {
        _detectedSubscriber = null;
        _subscriberChecked = false;
      });
      return;
    }
    final db = ref.read(databaseProvider);
    final sub = await db.findActiveSubscriberByPlate(
        PlateValidator.normalise(plate));
    if (mounted) {
      setState(() {
        _detectedSubscriber = sub;
        _subscriberChecked = true;
      });
    }
  }

  // ─── Submit ───────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    final rawPlate = _plateCtrl.text.trim();
    if (rawPlate.isEmpty) {
      _showError('Plaka numarası boş olamaz.');
      return;
    }

    final plate = PlateValidator.normalise(rawPlate);

    // 1. Turkish plate format check
    if (!PlateValidator.isTurkishPlate(plate)) {
      final proceed = await _showForeignPlateDialog(plate);
      if (!proceed) return;
    }

    // 2. Duplicate check
    final db = ref.read(databaseProvider);
    final existing = await db.getRecordByPlate(plate);
    if (existing != null) {
      _showError('$plate plakası şu anda otopark içinde!');
      return;
    }

    // 3. Get active tariff
    final tariff = await db.getActiveTariff();

    setState(() => _saving = true);

    try {
      await db.insertParkingRecord(ParkingRecordsCompanion.insert(
        plate: plate,
        entryTime: DateTime.now(),
        isSubscriber: Value(_detectedSubscriber != null),
        tariffId: Value(tariff?.id),
        status: const Value('inside'),
      ));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('$plate girişi kaydedildi.'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
        _plateCtrl.clear();
        setState(() {
          _detectedSubscriber = null;
          _subscriberChecked = false;
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
            icon: const Icon(Icons.warning_amber, color: Colors.orange, size: 40),
            title: const Text('Türk Plakası Değil'),
            content: Text(
              '"$plate" Türk plaka formatına uymuyor.\n\nYabancı araç olabilir. Yine de giriş kaydı oluşturulsun mu?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('İptal'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Devam Et'),
              ),
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

    return Scaffold(
      appBar: AppBar(title: const Text('Araç Girişi')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isTablet ? 500 : double.infinity),
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
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber,
                                  color: Colors.orange),
                              const SizedBox(width: 8),
                              const Expanded(
                                  child: Text(
                                      'Aktif tarife yok. Ücret hesaplanamaz.')),
                              TextButton(
                                onPressed: () => context.go('/tariff'),
                                child: const Text('Tarife Ekle'),
                              ),
                            ],
                          ),
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
                      color: Colors.grey,
                    ),
                    suffixIcon: _plateCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _plateCtrl.clear();
                              setState(() {
                                _detectedSubscriber = null;
                                _subscriberChecked = false;
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (v) {
                    setState(() {});
                    _checkSubscriber(v);
                  },
                  onSubmitted: (_) => _submit(),
                ),

                const SizedBox(height: 20),

                // ── Subscriber badge ───────────────────────────
                if (_subscriberChecked) ...[
                  if (_detectedSubscriber != null)
                    _SubscriberBadge(subscriber: _detectedSubscriber!)
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          const Text('Abonman kaydı bulunamadı.'),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                ],

                // ── Submit button ──────────────────────────────
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: _saving ? null : _submit,
                    icon: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.login),
                    label: const Text('Araç Girişini Kaydet',
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

// ─── Subscriber badge ─────────────────────────────────────────────────────────

class _SubscriberBadge extends StatelessWidget {
  const _SubscriberBadge({required this.subscriber});

  final Subscriber subscriber;

  @override
  Widget build(BuildContext context) {
    final endDate = subscriber.endDate;
    final daysLeft = endDate.difference(DateTime.now()).inDays;
    final endStr =
        '${endDate.day.toString().padLeft(2, '0')}.${endDate.month.toString().padLeft(2, '0')}.${endDate.year}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade300, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.card_membership, color: Colors.green.shade700, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Abonman Müşterisi',
                    style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text('Bitiş: $endStr ($daysLeft gün kaldı)',
                    style: TextStyle(color: Colors.green.shade700)),
                if (subscriber.notes != null && subscriber.notes!.isNotEmpty)
                  Text(subscriber.notes!,
                      style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
