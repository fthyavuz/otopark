import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/providers/settings_provider.dart';
import '../../shared/utils/currency_formatter.dart';
import 'cleaning_models.dart';

class CleaningServiceScreen extends ConsumerStatefulWidget {
  const CleaningServiceScreen({super.key, required this.data});

  final CleaningEntryData data;

  @override
  ConsumerState<CleaningServiceScreen> createState() =>
      _CleaningServiceScreenState();
}

class _CleaningServiceScreenState
    extends ConsumerState<CleaningServiceScreen> {
  CleaningServiceType? _selected;
  final _notesCtrl = TextEditingController();

  // Editable price controllers (only used if pricesEditable=true)
  late final Map<CleaningServiceType, TextEditingController> _priceControllers;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(cleaningSettingsProvider);
    _priceControllers = {
      for (final t in CleaningServiceType.values)
        t: TextEditingController(
            text: settings.priceForType(t.value).toStringAsFixed(0))
    };
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    for (final c in _priceControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  double _getBasePrice(CleaningServiceType type) {
    final settings = ref.read(cleaningSettingsProvider);
    if (settings.pricesEditable) {
      final text = _priceControllers[type]!.text.trim();
      return double.tryParse(text) ?? settings.priceForType(type.value);
    }
    return settings.priceForType(type.value);
  }

  double _getDiscount() {
    final settings = ref.read(cleaningSettingsProvider);
    final d = widget.data;
    if (!d.wasParkingCar) return 0.0;
    if (d.subscriberType == 'monthly') return settings.discountMonthly;
    if (d.subscriberType == 'daily') return settings.discountDaily;
    return settings.discountParked;
  }

  double _calcFinalCost(CleaningServiceType type) {
    double base = _getBasePrice(type);
    final discount = _getDiscount();
    if (discount > 0) base = base * (1.0 - discount / 100.0);
    if (widget.data.isLargeVehicle) base = base * 1.5;
    return base;
  }

  void _proceed() {
    if (_selected == null) return;
    final type = _selected!;
    final base = _getBasePrice(type);
    final discount = _getDiscount();
    final finalCost = _calcFinalCost(type);

    final note = _notesCtrl.text.trim();
    context.push(
      '/cleaning-payment',
      extra: CleaningPaymentData(
        plate: widget.data.plate,
        serviceType: type,
        baseCost: base,
        finalCost: finalCost,
        discountPercent: discount,
        isLargeVehicle: widget.data.isLargeVehicle,
        wasParkingCar: widget.data.wasParkingCar,
        notes: note.isEmpty ? null : note,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(cleaningSettingsProvider);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final discount = _getDiscount();

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.companyName),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.data.plate,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3),
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
          child: Column(
            children: [
              if (discount > 0 || widget.data.isLargeVehicle)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (discount > 0)
                        _infoBadge(
                            '${discount.toStringAsFixed(0)}% indirim uygulandı',
                            Colors.green),
                      if (widget.data.isLargeVehicle)
                        _infoBadge(
                            'Büyük araç: %50 ek ücret', Colors.orange),
                    ],
                  ),
                ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...CleaningServiceType.values.map((type) {
                      final finalCost = _calcFinalCost(type);
                      final isSelected = _selected == type;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ServiceTile(
                          type: type,
                          finalCost: finalCost,
                          isSelected: isSelected,
                          isEditable: settings.pricesEditable,
                          controller: _priceControllers[type]!,
                          isLargeVehicle: widget.data.isLargeVehicle,
                          discount: discount,
                          onTap: () =>
                              setState(() => _selected = type),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _notesCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Not (isteğe bağlı)',
                        hintText: 'Araç hakkında kısa not…',
                        prefixIcon: Icon(Icons.note_outlined),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      maxLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 56,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.teal),
                        onPressed: _selected == null ? null : _proceed,
                        icon: const Icon(Icons.payment),
                        label: Text(
                          _selected == null
                              ? 'Hizmet Seçin'
                              : 'Ödeme Ekranına Geç  •  ${CurrencyFormatter.format(_calcFinalCost(_selected!))}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.type,
    required this.finalCost,
    required this.isSelected,
    required this.isEditable,
    required this.controller,
    required this.isLargeVehicle,
    required this.discount,
    required this.onTap,
  });

  final CleaningServiceType type;
  final double finalCost;
  final bool isSelected;
  final bool isEditable;
  final TextEditingController controller;
  final bool isLargeVehicle;
  final double discount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.teal : Colors.transparent,
          width: 2.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.local_car_wash,
                  color: isSelected ? Colors.teal : Colors.grey.shade400,
                  size: 32),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type.displayName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isSelected ? Colors.teal.shade800 : null)),
                    Text(type.description,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              if (isEditable)
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      prefixText: '₺',
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormatter.format(finalCost),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.teal.shade700
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (discount > 0 || isLargeVehicle)
                      Text(
                        '(${discount > 0 ? "-${discount.toStringAsFixed(0)}%" : ""}${discount > 0 && isLargeVehicle ? " " : ""}${isLargeVehicle ? "+%50" : ""})',
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey.shade500),
                      ),
                  ],
                ),
              const SizedBox(width: 8),
              Icon(
                isSelected
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: isSelected ? Colors.teal : Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
