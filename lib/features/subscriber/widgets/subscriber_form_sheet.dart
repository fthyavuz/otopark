import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../database/database.dart';
import '../../../shared/providers/database_provider.dart';
import '../../../shared/utils/plate_validator.dart';
import '../subscriber_models.dart';

void showSubscriberFormSheet(
  BuildContext context, {
  SubscriberWithPlates? existing,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => SubscriberFormSheet(existing: existing),
  );
}

class SubscriberFormSheet extends ConsumerStatefulWidget {
  const SubscriberFormSheet({super.key, this.existing});

  final SubscriberWithPlates? existing;

  @override
  ConsumerState<SubscriberFormSheet> createState() =>
      _SubscriberFormSheetState();
}

class _SubscriberFormSheetState extends ConsumerState<SubscriberFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _notesCtrl;
  late final TextEditingController _feeCtrl;
  late final TextEditingController _dailyFeeCtrl;

  late DateTime _startDate;
  late DateTime _endDate;
  late SubType _subType;

  final List<TextEditingController> _plateCtrls = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final ex = widget.existing;

    _subType = ex?.type ?? SubType.monthly;
    _notesCtrl = TextEditingController(text: ex?.subscriber.notes ?? '');
    _feeCtrl = TextEditingController(
      text: ex?.subscriber.monthlyFee != null &&
              ex!.subscriber.monthlyFee > 0
          ? ex.subscriber.monthlyFee.toStringAsFixed(0)
          : '',
    );
    _dailyFeeCtrl = TextEditingController(
      text: ex?.subscriber.dailyFee?.toStringAsFixed(0) ?? '150',
    );

    final now = DateTime.now();
    _startDate = ex?.subscriber.startDate ??
        DateTime(now.year, now.month, 1);
    _endDate = ex?.subscriber.endDate ??
        DateTime(now.year, now.month + 1, 0);

    if (ex != null && ex.plates.isNotEmpty) {
      for (final p in ex.plates) {
        _plateCtrls.add(TextEditingController(text: p.plate));
      }
    } else {
      _plateCtrls.add(TextEditingController());
    }

    if (ex == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _prefillFee());
    }
  }

  Future<void> _prefillFee() async {
    final tariff = await ref.read(databaseProvider).getActiveTariff();
    if (tariff != null && mounted && _feeCtrl.text.isEmpty) {
      setState(() {
        _feeCtrl.text = tariff.monthlyPrice.toStringAsFixed(0);
      });
    }
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _feeCtrl.dispose();
    _dailyFeeCtrl.dispose();
    for (final c in _plateCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  // ─── Date pickers ─────────────────────────────────────────────────────────

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _endDate.isBefore(_startDate) ? _startDate : _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2035),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  // ─── Plate management ─────────────────────────────────────────────────────

  void _addPlateRow() =>
      setState(() => _plateCtrls.add(TextEditingController()));

  void _removePlateRow(int i) {
    if (_plateCtrls.length <= 1) return;
    setState(() {
      _plateCtrls[i].dispose();
      _plateCtrls.removeAt(i);
    });
  }

  // ─── Save ─────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final plates = _plateCtrls
        .map((c) => PlateValidator.normalise(c.text))
        .where((p) => p.isNotEmpty)
        .toList();

    if (plates.isEmpty) {
      _showError('En az bir plaka eklemelisiniz.');
      return;
    }

    for (final plate in plates) {
      if (!PlateValidator.isTurkishPlate(plate)) {
        final proceed = await _showForeignPlateDialog(plate);
        if (!proceed) return;
      }
    }

    setState(() => _saving = true);
    final db = ref.read(databaseProvider);

    // For daily subscribers we set endDate far in the future so they don't expire.
    final effectiveEndDate = _subType == SubType.daily
        ? DateTime(2099, 12, 31)
        : _endDate;

    final monthlyFeeValue = _subType == SubType.monthly &&
            _feeCtrl.text.trim().isNotEmpty
        ? double.parse(_feeCtrl.text.trim())
        : 0.0;

    final dailyFeeValue = _subType == SubType.daily &&
            _dailyFeeCtrl.text.trim().isNotEmpty
        ? double.parse(_dailyFeeCtrl.text.trim())
        : 150.0;

    try {
      if (widget.existing != null) {
        final id = widget.existing!.subscriber.id;
        await db.updateSubscriber(SubscribersCompanion(
          id: Value(id),
          notes: Value(_notesCtrl.text.trim().isEmpty
              ? null
              : _notesCtrl.text.trim()),
          startDate: Value(_startDate),
          endDate: Value(effectiveEndDate),
          monthlyFee: Value(monthlyFeeValue),
          dailyFee: Value(
              _subType == SubType.daily ? dailyFeeValue : null),
          subscriberType: Value(
              _subType == SubType.daily ? 'daily' : 'monthly'),
          isActive: Value(true),
        ));
        await db.replaceSubscriberPlates(id, plates);
      } else {
        final id = await db.insertSubscriber(SubscribersCompanion.insert(
          notes: Value(_notesCtrl.text.trim().isEmpty
              ? null
              : _notesCtrl.text.trim()),
          startDate: _startDate,
          endDate: effectiveEndDate,
          monthlyFee: monthlyFeeValue,
          dailyFee: Value(
              _subType == SubType.daily ? dailyFeeValue : null),
          subscriberType:
              Value(_subType == SubType.daily ? 'daily' : 'monthly'),
          isActive: Value(true),
        ));
        await db.replaceSubscriberPlates(id, plates);
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _showError('Kayıt sırasında hata: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<bool> _showForeignPlateDialog(String plate) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Türk Plakası Değil'),
            content: Text(
                '"$plate" Türk plaka formatına uymuyor. Yine de eklensin mi?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('İptal')),
              FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Ekle')),
            ],
          ),
        ) ??
        false;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollCtrl) => Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(isEdit ? 'Abonmanı Düzenle' : 'Yeni Abonman',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // ── Subscriber type toggle ────────────────
                    Text('Abonman Türü',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    SegmentedButton<SubType>(
                      segments: const [
                        ButtonSegment(
                          value: SubType.monthly,
                          label: Text('Aylık'),
                          icon: Icon(Icons.calendar_month),
                        ),
                        ButtonSegment(
                          value: SubType.daily,
                          label: Text('Günlük'),
                          icon: Icon(Icons.today),
                        ),
                      ],
                      selected: {_subType},
                      onSelectionChanged: (s) =>
                          setState(() => _subType = s.first),
                    ),
                    const SizedBox(height: 20),

                    // Notes
                    TextFormField(
                      controller: _notesCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Not (isteğe bağlı)',
                        hintText: 'Örn: Şirket adı, araç sahibi...',
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),

                    // Date row — only for monthly
                    if (_subType == SubType.monthly) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _DateField(
                              label: 'Başlangıç',
                              value: dateFormat.format(_startDate),
                              onTap: _pickStartDate,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DateField(
                              label: 'Bitiş',
                              value: dateFormat.format(_endDate),
                              onTap: _pickEndDate,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Monthly fee
                      TextFormField(
                        controller: _feeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Aylık Ücret (₺)',
                          prefixText: '₺ ',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Zorunlu alan';
                          }
                          final n = double.tryParse(v);
                          if (n == null || n <= 0) {
                            return 'Geçerli bir tutar girin';
                          }
                          return null;
                        },
                      ),
                    ],

                    // Daily fee — only for daily
                    if (_subType == SubType.daily) ...[
                      TextFormField(
                        controller: _dailyFeeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Günlük Ücret (₺)',
                          prefixText: '₺ ',
                          hintText: '150',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Zorunlu alan';
                          }
                          final n = double.tryParse(v);
                          if (n == null || n <= 0) {
                            return 'Geçerli bir tutar girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.teal.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline,
                                size: 16, color: Colors.teal.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Günlük abone plakalar, kayıtlı oldukları her gün için bir kez bu ücret öder. '
                                'Aynı gün içindeki sonraki giriş/çıkışlar ücretsizdir.',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Plates header
                    Row(
                      children: [
                        Text('Plakalar',
                            style:
                                Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _addPlateRow,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Plaka Ekle'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    ..._plateCtrls.asMap().entries.map((e) => _PlateRow(
                          controller: e.value,
                          onRemove: _plateCtrls.length > 1
                              ? () => _removePlateRow(e.key)
                              : null,
                        )),

                    const SizedBox(height: 32),

                    FilledButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white),
                            )
                          : const Text('Kaydet'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Date field ───────────────────────────────────────────────────────────────

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(value,
            style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

// ─── Plate row ────────────────────────────────────────────────────────────────

class _PlateRow extends StatelessWidget {
  const _PlateRow({required this.controller, this.onRemove});

  final TextEditingController controller;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
              decoration: const InputDecoration(
                hintText: '34 ABC 1234',
                isDense: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Boş bırakılamaz';
                return null;
              },
              onChanged: (v) {
                final upper = v.toUpperCase();
                if (v != upper) {
                  controller.value = controller.value.copyWith(
                    text: upper,
                    selection:
                        TextSelection.collapsed(offset: upper.length),
                  );
                }
              },
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
