import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/database.dart';
import '../../../shared/providers/database_provider.dart';
import '../../../shared/utils/currency_formatter.dart';

// ─── Bracket row state ────────────────────────────────────────────────────────

class _BracketRow {
  final TextEditingController minutesCtrl;
  final TextEditingController priceCtrl;

  _BracketRow({String minutes = '', String price = ''})
      : minutesCtrl = TextEditingController(text: minutes),
        priceCtrl = TextEditingController(text: price);

  void dispose() {
    minutesCtrl.dispose();
    priceCtrl.dispose();
  }
}

// ─── Public entry point ───────────────────────────────────────────────────────

/// Shows the tariff form as a modal bottom sheet.
///
/// [existingTariff] — provide to pre-fill (edit mode).
/// [isEditing] — true = update active tariff in place; false = archive old + create new.
void showTariffFormSheet(
  BuildContext context, {
  Tariff? existingTariff,
  bool isEditing = false,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => TariffFormSheet(
      existingTariff: existingTariff,
      isEditing: isEditing,
    ),
  );
}

// ─── Form widget ──────────────────────────────────────────────────────────────

class TariffFormSheet extends ConsumerStatefulWidget {
  final Tariff? existingTariff;
  final bool isEditing;

  const TariffFormSheet({
    super.key,
    this.existingTariff,
    this.isEditing = false,
  });

  @override
  ConsumerState<TariffFormSheet> createState() => _TariffFormSheetState();
}

class _TariffFormSheetState extends ConsumerState<TariffFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _fullDayCtrl;
  late final TextEditingController _monthlyCtrl;
  late List<_BracketRow> _brackets;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.existingTariff;
    _nameCtrl = TextEditingController(text: t?.name ?? '');
    _fullDayCtrl =
        TextEditingController(text: t?.fullDayPrice.toStringAsFixed(0) ?? '');
    _monthlyCtrl =
        TextEditingController(text: t?.monthlyPrice.toStringAsFixed(0) ?? '');

    if (t != null) {
      final list = jsonDecode(t.bracketsJson) as List;
      _brackets = list
          .map((e) => _BracketRow(
                minutes: (e['upToMinutes'] as int).toString(),
                price: (e['price'] as num).toStringAsFixed(0),
              ))
          .toList();
    } else {
      // Default brackets matching the seeded tariff.
      _brackets = [
        _BracketRow(minutes: '60', price: '100'),
        _BracketRow(minutes: '120', price: '150'),
        _BracketRow(minutes: '240', price: '200'),
      ];
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _fullDayCtrl.dispose();
    _monthlyCtrl.dispose();
    for (final b in _brackets) {
      b.dispose();
    }
    super.dispose();
  }

  // ─── Validation & save ─────────────────────────────────────────────────────

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Validate brackets are in strictly ascending order.
    final minuteValues = _brackets
        .map((b) => int.tryParse(b.minutesCtrl.text.trim()) ?? 0)
        .toList();
    for (int i = 1; i < minuteValues.length; i++) {
      if (minuteValues[i] <= minuteValues[i - 1]) {
        _showError('Süre dilimleri artan sırada olmalıdır.');
        return;
      }
    }

    setState(() => _saving = true);

    final bracketsJson = jsonEncode(_brackets
        .map((b) => {
              'upToMinutes': int.parse(b.minutesCtrl.text.trim()),
              'price': double.parse(b.priceCtrl.text.trim()),
            })
        .toList());

    final db = ref.read(databaseProvider);
    final now = DateTime.now();

    try {
      if (widget.isEditing && widget.existingTariff != null) {
        await db.editActiveTariff(TariffsCompanion(
          id: Value(widget.existingTariff!.id),
          name: Value(_nameCtrl.text.trim()),
          bracketsJson: Value(bracketsJson),
          fullDayPrice: Value(double.parse(_fullDayCtrl.text.trim())),
          monthlyPrice: Value(double.parse(_monthlyCtrl.text.trim())),
        ));
      } else {
        await db.switchToNewTariff(TariffsCompanion.insert(
          name: _nameCtrl.text.trim(),
          bracketsJson: bracketsJson,
          fullDayPrice: double.parse(_fullDayCtrl.text.trim()),
          monthlyPrice: double.parse(_monthlyCtrl.text.trim()),
          validFrom: now,
        ));
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _showError('Kayıt sırasında hata oluştu: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _addBracket() {
    setState(() => _brackets.add(_BracketRow()));
  }

  void _removeBracket(int index) {
    if (_brackets.length <= 1) {
      _showError('En az bir süre dilimi olmalıdır.');
      return;
    }
    setState(() {
      _brackets[index].dispose();
      _brackets.removeAt(index);
    });
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final title = widget.isEditing ? 'Tarife Düzenle' : 'Yeni Tarife';

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
            // ── Handle ──────────────────────────────────────────
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
            // ── Title row ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(),
            // ── Form ─────────────────────────────────────────────
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Name
                    TextFormField(
                      controller: _nameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Tarife Adı'),
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null,
                    ),
                    const SizedBox(height: 24),

                    // Bracket list header
                    Row(
                      children: [
                        Text('Süre Dilimleri',
                            style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _addBracket,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Dilim Ekle'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Column headers
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text('Süre (dakika)',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey))),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Text('Ücret (₺)',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey))),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Bracket rows
                    ..._brackets.asMap().entries.map((e) =>
                        _BracketRowWidget(
                          row: e.value,
                          onRemove: () => _removeBracket(e.key),
                        )),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 12),

                    // Full day price
                    TextFormField(
                      controller: _fullDayCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Günlük Tarife (₺)',
                        hintText: 'Örn: 400',
                        prefixText: '₺ ',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Zorunlu alan';
                        final n = double.tryParse(v);
                        if (n == null || n <= 0) return 'Geçerli bir tutar girin';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Monthly price
                    TextFormField(
                      controller: _monthlyCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Aylık Abonman (₺)',
                        hintText: 'Örn: 4000',
                        prefixText: '₺ ',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Zorunlu alan';
                        final n = double.tryParse(v);
                        if (n == null || n <= 0) return 'Geçerli bir tutar girin';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Save button
                    FilledButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
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

// ─── Single bracket row widget ────────────────────────────────────────────────

class _BracketRowWidget extends StatelessWidget {
  const _BracketRowWidget({required this.row, required this.onRemove});

  final _BracketRow row;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              controller: row.minutesCtrl,
              decoration: const InputDecoration(
                hintText: 'Örn: 60',
                suffixText: 'dk',
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Zorunlu';
                final n = int.tryParse(v);
                if (n == null || n <= 0) return 'Geçersiz';
                return null;
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: row.priceCtrl,
              decoration: const InputDecoration(
                hintText: 'Örn: 100',
                prefixText: '₺ ',
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Zorunlu';
                final n = double.tryParse(v);
                if (n == null || n <= 0) return 'Geçersiz';
                return null;
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onRemove,
            tooltip: 'Sil',
          ),
        ],
      ),
    );
  }
}

// ─── Display helper ───────────────────────────────────────────────────────────

/// Shows a read-only summary card of bracket prices.
class TariffBracketsDisplay extends StatelessWidget {
  const TariffBracketsDisplay({super.key, required this.tariff});

  final Tariff tariff;

  @override
  Widget build(BuildContext context) {
    List<dynamic> brackets = [];
    try {
      brackets = jsonDecode(tariff.bracketsJson) as List;
    } catch (_) {}

    int prevMinutes = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...brackets.map((e) {
          final upTo = e['upToMinutes'] as int;
          final price = (e['price'] as num).toDouble();
          final fromLabel = prevMinutes == 0
              ? '0'
              : _minuteLabel(prevMinutes);
          final toLabel = _minuteLabel(upTo);
          prevMinutes = upTo;
          return _TariffRow(
            label: '$fromLabel – $toLabel',
            value: CurrencyFormatter.format(price),
          );
        }),
        _TariffRow(
          label: 'Günlük (${_minuteLabel(prevMinutes)}+)',
          value: CurrencyFormatter.format(tariff.fullDayPrice),
          isHighlighted: true,
        ),
        _TariffRow(
          label: 'Aylık Abonman',
          value: CurrencyFormatter.format(tariff.monthlyPrice),
          isHighlighted: true,
        ),
      ],
    );
  }

  static String _minuteLabel(int minutes) {
    if (minutes < 60) return '$minutes dk';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h sa' : '$h sa $m dk';
  }
}

class _TariffRow extends StatelessWidget {
  const _TariffRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  final String label;
  final String value;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final style = isHighlighted
        ? const TextStyle(fontWeight: FontWeight.bold)
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
