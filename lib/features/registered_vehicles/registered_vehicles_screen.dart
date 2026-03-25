import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../database/database.dart';
import '../../shared/providers/database_provider.dart';

// ─── Provider ─────────────────────────────────────────────────────────────────

final registeredVehiclesListProvider =
    StreamProvider<List<RegisteredVehicle>>((ref) {
  return ref.read(databaseProvider).watchAllRegisteredVehicles();
});

// ─── Screen ───────────────────────────────────────────────────────────────────

class RegisteredVehiclesScreen extends ConsumerStatefulWidget {
  const RegisteredVehiclesScreen({
    super.key,
    this.showAppBar = true,
    this.isAdmin = false,
  });

  final bool showAppBar;
  final bool isAdmin;

  @override
  ConsumerState<RegisteredVehiclesScreen> createState() =>
      _RegisteredVehiclesScreenState();
}

class _RegisteredVehiclesScreenState
    extends ConsumerState<RegisteredVehiclesScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _typeFilter = 'all'; // 'all' | 'normal' | 'large'
  String _subFilter = 'all'; // 'all' | 'none' | 'daily' | 'monthly'

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _matches(RegisteredVehicle v) {
    final matchesQuery = _query.isEmpty ||
        v.plate
            .replaceAll(' ', '')
            .contains(_query.replaceAll(' ', '').toUpperCase());
    final matchesType = _typeFilter == 'all' || v.vehicleType == _typeFilter;
    final matchesSub = _subFilter == 'all' || v.subscriptionType == _subFilter;
    return matchesQuery && matchesType && matchesSub;
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(registeredVehiclesListProvider);

    final body = Column(
      children: [
        // ── Type filter chips ────────────────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              const Text('Tip: ',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              for (final entry in const [
                ('all', 'Tümü'),
                ('normal', 'Normal'),
                ('large', 'Büyük'),
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(entry.$2),
                    selected: _typeFilter == entry.$1,
                    onSelected: (_) =>
                        setState(() => _typeFilter = entry.$1),
                  ),
                ),
              const SizedBox(width: 12),
              const Text('Abonelik: ',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              for (final entry in const [
                ('all', 'Tümü'),
                ('none', 'Yok'),
                ('daily', 'Günlük'),
                ('monthly', 'Aylık'),
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(entry.$2),
                    selected: _subFilter == entry.$1,
                    onSelected: (_) =>
                        setState(() => _subFilter = entry.$1),
                  ),
                ),
            ],
          ),
        ),

        // ── Search bar ───────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: TextField(
            controller: _searchCtrl,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'Plaka ile ara…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              isDense: true,
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),

        // ── Vehicle list ─────────────────────────────────────
        Expanded(
          child: vehiclesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Hata: $e')),
            data: (vehicles) {
              final filtered = vehicles.where(_matches).toList();
              if (filtered.isEmpty) {
                return const Center(
                  child: Text('Kayıtlı araç yok.',
                      style: TextStyle(color: Colors.grey)),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: filtered.length,
                itemBuilder: (_, i) => _RegisteredVehicleTile(
                  vehicle: filtered[i],
                  isAdmin: widget.isAdmin,
                ),
              );
            },
          ),
        ),
      ],
    );

    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kayıtlı Araçlar')),
        body: body,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddVehicleDialog(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('Araç Ekle'),
        ),
      );
    }

    // Embedded in admin panel — no AppBar, FAB still present via Scaffold
    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVehicleDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Araç Ekle'),
      ),
    );
  }

  Future<void> _showAddVehicleDialog(BuildContext context, WidgetRef ref) async {
    final plateCtrl = TextEditingController();
    String selectedType = 'normal';
    String selectedSub = 'none';
    final feeCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: const Text('Araç Ön Kaydı'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: plateCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Plaka',
                    hintText: '34 ABC 1234',
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Araç Tipi',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'normal', label: Text('Normal')),
                    ButtonSegment(value: 'large', label: Text('Büyük')),
                  ],
                  selected: {selectedType},
                  onSelectionChanged: (s) =>
                      setSt(() => selectedType = s.first),
                ),
                const SizedBox(height: 16),
                const Text('Abonelik',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'none', label: Text('Yok')),
                    ButtonSegment(value: 'daily', label: Text('Günlük')),
                    ButtonSegment(value: 'monthly', label: Text('Aylık')),
                  ],
                  selected: {selectedSub},
                  onSelectionChanged: (s) => setSt(() => selectedSub = s.first),
                ),
                if (selectedSub == 'monthly') ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: feeCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Aylık Ücret (₺)',
                      prefixText: '₺ ',
                      isDense: true,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () async {
                final plate = plateCtrl.text.trim().toUpperCase();
                if (plate.isEmpty) return;
                final fee = double.tryParse(feeCtrl.text.trim()) ?? 0.0;
                final now = DateTime.now();
                await ref.read(databaseProvider).upsertRegisteredVehicle(
                      RegisteredVehiclesCompanion(
                        plate: Value(plate),
                        vehicleType: Value(selectedType),
                        subscriptionType: Value(selectedSub),
                        monthlyFee: Value(fee),
                        subscriptionStartDate: selectedSub == 'monthly'
                            ? Value(now)
                            : const Value(null),
                        subscriptionEndDate: selectedSub == 'monthly'
                            ? Value(now.add(const Duration(days: 30)))
                            : const Value(null),
                        createdAt: Value(now),
                      ),
                    );
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
    plateCtrl.dispose();
    feeCtrl.dispose();
  }
}

// ─── Vehicle tile ─────────────────────────────────────────────────────────────

class _RegisteredVehicleTile extends ConsumerWidget {
  const _RegisteredVehicleTile({
    required this.vehicle,
    required this.isAdmin,
  });

  final RegisteredVehicle vehicle;
  final bool isAdmin;

  String _subLabel() {
    switch (vehicle.subscriptionType) {
      case 'monthly':
        final end = vehicle.subscriptionEndDate;
        if (end == null) return 'Aylık Abonman';
        final remaining = end.difference(DateTime.now()).inDays;
        return remaining > 0
            ? 'Aylık Abonman — $remaining gün kaldı'
            : 'Aylık Abonman — Süresi Doldu';
      case 'daily':
        return 'Günlük Abone';
      default:
        return 'Abonelik Yok';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLarge = vehicle.vehicleType == 'large';
    final fmt = DateFormat('dd.MM.yyyy');

    Widget subBadge() {
      switch (vehicle.subscriptionType) {
        case 'monthly':
          return _badge('AYLIK', Colors.green);
        case 'daily':
          return _badge('GÜNLÜK', Colors.blue);
        default:
          return _badge('YOK', Colors.grey);
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Icon(
          isLarge ? Icons.local_shipping : Icons.directions_car,
          color: isLarge ? Colors.orange : null,
        ),
        title: Row(
          children: [
            Text(
              vehicle.plate,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(width: 8),
            _badge(isLarge ? 'BÜYÜK' : 'NORMAL',
                isLarge ? Colors.orange : Colors.grey),
            const SizedBox(width: 4),
            subBadge(),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_subLabel()),
            if (vehicle.subscriptionEndDate != null)
              Text('Bitiş: ${fmt.format(vehicle.subscriptionEndDate!)}'),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => _showEditDialog(context, ref),
              tooltip: 'Düzenle',
            ),
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    size: 20, color: Colors.red),
                onPressed: () => _showDeleteDialog(context, ref),
                tooltip: 'Sil',
              ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    String selectedType = vehicle.vehicleType;
    String selectedSub = vehicle.subscriptionType;
    final feeCtrl = TextEditingController(
        text: vehicle.monthlyFee > 0
            ? vehicle.monthlyFee.toStringAsFixed(0)
            : '');

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: Text('Araç Düzenle — ${vehicle.plate}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Araç Tipi',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 6),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'normal', label: Text('Normal')),
                  ButtonSegment(value: 'large', label: Text('Büyük')),
                ],
                selected: {selectedType},
                onSelectionChanged: (s) =>
                    setSt(() => selectedType = s.first),
              ),
              const SizedBox(height: 16),
              const Text('Abonelik',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 6),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'none', label: Text('Yok')),
                  ButtonSegment(value: 'daily', label: Text('Günlük')),
                  ButtonSegment(value: 'monthly', label: Text('Aylık')),
                ],
                selected: {selectedSub},
                onSelectionChanged: (s) =>
                    setSt(() => selectedSub = s.first),
              ),
              if (selectedSub == 'monthly') ...[
                const SizedBox(height: 12),
                TextField(
                  controller: feeCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Aylık Ücret (₺)',
                    prefixText: '₺ ',
                    isDense: true,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () async {
                final fee = double.tryParse(feeCtrl.text.trim()) ??
                    vehicle.monthlyFee;
                await ref.read(databaseProvider).updateRegisteredVehicle(
                      RegisteredVehiclesCompanion(
                        id: Value(vehicle.id),
                        plate: Value(vehicle.plate),
                        vehicleType: Value(selectedType),
                        subscriptionType: Value(selectedSub),
                        monthlyFee: Value(fee),
                        createdAt: Value(vehicle.createdAt),
                      ),
                    );
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
    feeCtrl.dispose();
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final hasPayments = await db.hasPaymentRecordsForPlate(vehicle.plate);

    if (!context.mounted) return;

    if (hasPayments) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.info_outline, color: Colors.orange, size: 40),
          title: const Text('Silme Engellendi'),
          content: const Text(
            'Bu araç için ödeme kaydı mevcut. Önce "Park Kayıtları" bölümünden kayıtları silin.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber, color: Colors.red, size: 40),
        title: const Text('Aracı Sil'),
        content: Text(
            '${vehicle.plate} plakalı araç kaydı silinecek. Bu işlem geri alınamaz.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('İptal')),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(databaseProvider).deleteRegisteredVehicle(vehicle.id);
    }
  }
}
