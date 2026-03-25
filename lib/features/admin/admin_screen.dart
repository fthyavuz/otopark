import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../database/database.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/settings_provider.dart';
import '../../shared/utils/currency_formatter.dart';
import '../../shared/widgets/park_logo.dart';
import '../registered_vehicles/registered_vehicles_screen.dart';
import '../tariff/tariff_providers.dart';
import '../tariff/tariff_screen.dart';
import '../tariff/widgets/tariff_form_sheet.dart';

// ─── Password gate ────────────────────────────────────────────────────────────

const _adminPassword = '1234';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  bool _authenticated = false;
  final _pinCtrl = TextEditingController();
  String? _pinError;

  @override
  void dispose() {
    _pinCtrl.dispose();
    super.dispose();
  }

  void _checkPin() {
    if (_pinCtrl.text.trim() == _adminPassword) {
      setState(() {
        _authenticated = true;
        _pinError = null;
      });
    } else {
      setState(() => _pinError = 'Hatalı şifre. Tekrar deneyin.');
      _pinCtrl.clear();
    }
  }

  // ─── PIN gate screen ──────────────────────────────────────────────────────

  Widget _buildPinScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Yönetici Girişi')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.admin_panel_settings,
                    size: 72, color: Colors.grey),
                const SizedBox(height: 24),
                const Text(
                  'Yönetici Paneli',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Devam etmek için şifreyi girin.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _pinCtrl,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    errorText: _pinError,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  onSubmitted: (_) => _checkPin(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _checkPin,
                    child: const Text('Giriş'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_authenticated) return _buildPinScreen();
    return const _AdminPanel();
  }
}

// ─── Admin panel ──────────────────────────────────────────────────────────────

class _AdminPanel extends ConsumerStatefulWidget {
  const _AdminPanel();

  @override
  ConsumerState<_AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends ConsumerState<_AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Yönetici Paneli'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.receipt_long), text: 'Park Kayıtları'),
              Tab(icon: Icon(Icons.app_registration), text: 'Kayıtlı Araçlar'),
              Tab(icon: Icon(Icons.price_change_outlined), text: 'Tarife'),
              Tab(icon: Icon(Icons.settings_outlined), text: 'Ayarlar'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _RecordsTab(),
            _RegisteredVehiclesTab(),
            _TariffTab(),
            _SettingsTab(),
          ],
        ),
      ),
    );
  }
}

// ─── Records tab ─────────────────────────────────────────────────────────────

class _RecordsTab extends ConsumerStatefulWidget {
  const _RecordsTab();

  @override
  ConsumerState<_RecordsTab> createState() => _RecordsTabState();
}

class _RecordsTabState extends ConsumerState<_RecordsTab> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _filterPeriod = 'all';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _recordMatchesPeriod(ParkingRecord r) {
    if (_filterPeriod == 'all') return true;
    final now = DateTime.now();
    final ref = r.entryTime;
    switch (_filterPeriod) {
      case 'today':
        return ref.year == now.year &&
            ref.month == now.month &&
            ref.day == now.day;
      case 'week':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekStartDay =
            DateTime(weekStart.year, weekStart.month, weekStart.day);
        return ref.isAfter(weekStartDay.subtract(const Duration(seconds: 1)));
      case 'month':
        return ref.year == now.year && ref.month == now.month;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(_allRecordsProvider);

    return Column(
      children: [
        // Date filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              for (final entry in const [
                ('today', 'Bugün'),
                ('week', 'Bu Hafta'),
                ('month', 'Bu Ay'),
                ('all', 'Tümü'),
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(entry.$2),
                    selected: _filterPeriod == entry.$1,
                    onSelected: (_) =>
                        setState(() => _filterPeriod = entry.$1),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: TextField(
            controller: _searchCtrl,
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
            onChanged: (v) => setState(() => _query = v.toUpperCase().trim()),
          ),
        ),
        Expanded(
          child: recordsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Hata: $e')),
            data: (records) {
              final filtered = records.where((r) {
                final matchesQuery = _query.isEmpty ||
                    r.plate
                        .replaceAll(' ', '')
                        .contains(_query.replaceAll(' ', ''));
                return matchesQuery && _recordMatchesPeriod(r);
              }).toList();

              if (filtered.isEmpty) {
                return const Center(
                  child:
                      Text('Kayıt bulunamadı.', style: TextStyle(color: Colors.grey)),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: filtered.length,
                itemBuilder: (_, i) => _RecordTile(record: filtered[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

final _allRecordsProvider =
    StreamProvider<List<ParkingRecord>>((ref) {
  return ref.read(databaseProvider).watchAllRecords();
});

// ─── Record tile ──────────────────────────────────────────────────────────────

class _RecordTile extends ConsumerWidget {
  const _RecordTile({required this.record});

  final ParkingRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fmt = DateFormat('dd.MM.yy HH:mm');
    final isInside = record.status == 'inside';
    final cost = record.calculatedCost;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Icon(
          record.isLargeVehicle ? Icons.local_shipping : Icons.directions_car,
          color: record.isLargeVehicle ? Colors.orange : null,
        ),
        title: Text(
          record.plate,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Giriş: ${fmt.format(record.entryTime)}'),
            if (record.exitTime != null)
              Text('Çıkış: ${fmt.format(record.exitTime!)}'),
            if (cost != null && cost > 0)
              Text('Ücret: ${CurrencyFormatter.format(cost)}'),
            if (record.isSubscriber) const Text('Aylık Abonman'),
            if (record.isDailySubscriber) const Text('Günlük Abone'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isInside ? Colors.green.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isInside ? 'İÇERİDE' : 'ÇIKTI',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isInside ? Colors.green.shade800 : Colors.grey.shade700,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => _showEditDialog(context, ref),
              tooltip: 'Düzenle',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  size: 20, color: Colors.red),
              onPressed: () => _showDeleteDialog(context, ref),
              tooltip: 'Sil',
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    final costCtrl = TextEditingController(
        text: record.calculatedCost?.toStringAsFixed(0) ?? '');
    final notesCtrl =
        TextEditingController(text: record.notes ?? '');

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Kaydı Düzenle — ${record.plate}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: costCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Ücret (₺)',
                prefixText: '₺ ',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesCtrl,
              decoration: const InputDecoration(labelText: 'Not'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () async {
              final newCost =
                  double.tryParse(costCtrl.text.trim());
              await ref.read(databaseProvider).updateParkingRecord(
                    ParkingRecordsCompanion(
                      id: Value(record.id),
                      plate: Value(record.plate),
                      entryTime: Value(record.entryTime),
                      tariffId: Value(record.tariffId),
                      status: Value(record.status),
                      isSubscriber: Value(record.isSubscriber),
                      isLargeVehicle: Value(record.isLargeVehicle),
                      isDailySubscriber: Value(record.isDailySubscriber),
                      calculatedCost: newCost != null
                          ? Value(newCost)
                          : const Value.absent(),
                      notes: Value(notesCtrl.text.trim().isEmpty
                          ? null
                          : notesCtrl.text.trim()),
                    ),
                  );
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
    costCtrl.dispose();
    notesCtrl.dispose();
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber, color: Colors.red, size: 40),
        title: const Text('Kaydı Sil'),
        content: Text(
            '${record.plate} plakalı araç kaydı silinecek. Bu işlem geri alınamaz.'),
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
      await ref.read(databaseProvider).deleteParkingRecord(record.id);
    }
  }
}

// ─── Registered vehicles tab ──────────────────────────────────────────────────

class _RegisteredVehiclesTab extends StatelessWidget {
  const _RegisteredVehiclesTab();

  @override
  Widget build(BuildContext context) {
    return const RegisteredVehiclesScreen(showAppBar: false, isAdmin: true);
  }
}

// ─── Tariff tab ───────────────────────────────────────────────────────────────

class _TariffTab extends ConsumerWidget {
  const _TariffTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTariffAsync = ref.watch(activeTariffProvider);
    final allTariffsAsync = ref.watch(allTariffsProvider);

    return Scaffold(
      body: allTariffsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (allTariffs) {
          final active = allTariffs.where((t) => t.isActive).toList();
          final history = allTariffs.where((t) => !t.isActive).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              Text('Aktif Tarife',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              const SizedBox(height: 8),
              if (active.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Aktif tarife yok. Yeni tarife oluşturun.'),
                  ),
                )
              else
                ActiveTariffCard(tariff: active.first, readOnly: false),
              if (history.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('Geçmiş Tarifeler',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 8),
                ...history.map((t) => HistoryTariffTile(key: ValueKey(t.id), tariff: t)),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTariffFormSheet(
          context,
          existingTariff: activeTariffAsync.value,
          isEditing: false,
        ),
        icon: const Icon(Icons.add),
        label: const Text('Yeni Tarife'),
      ),
    );
  }
}

// ─── Settings tab ─────────────────────────────────────────────────────────────

class _SettingsTab extends ConsumerStatefulWidget {
  const _SettingsTab();

  @override
  ConsumerState<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<_SettingsTab> {
  @override
  Widget build(BuildContext context) {
    final lotName = ref.watch(lotNameProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const ParkLogo(size: 36),
            title: const Text('Otopark Adı'),
            subtitle: Text(lotName.isEmpty ? 'Henüz ayarlanmadı' : lotName),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () => _showNameDialog(context, lotName),
          ),
        ),
      ],
    );
  }

  Future<void> _showNameDialog(BuildContext context, String current) async {
    final ctrl = TextEditingController(text: current);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const ParkLogo(size: 40),
        title: const Text('Otopark Adı'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Otopark adı',
            hintText: 'Örn: Merkez Otopark',
            prefixIcon: Icon(Icons.local_parking),
          ),
          onSubmitted: (_) => _save(ctrl, ctx),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('İptal')),
          FilledButton(
              onPressed: () => _save(ctrl, ctx),
              child: const Text('Kaydet')),
        ],
      ),
    );
    ctrl.dispose();
  }

  void _save(TextEditingController ctrl, BuildContext ctx) {
    final name = ctrl.text.trim();
    if (name.isEmpty) return;
    Navigator.of(ctx).pop();
    ref.read(lotNameProvider.notifier).setName(name);
  }
}
