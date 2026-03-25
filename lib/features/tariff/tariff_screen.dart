import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../database/database.dart';
import 'tariff_providers.dart';
import 'widgets/tariff_form_sheet.dart';

class TariffScreen extends ConsumerWidget {
  const TariffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTariffsAsync = ref.watch(allTariffsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tarife Bilgisi')),
      body: allTariffsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (allTariffs) {
          final active = allTariffs.where((t) => t.isActive).toList();
          final history = allTariffs.where((t) => !t.isActive).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // ── Active tariff ────────────────────────────────────
              Text('Aktif Tarife',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              const SizedBox(height: 8),
              if (active.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.orange, size: 40),
                        SizedBox(height: 8),
                        Text('Aktif tarife bulunamadı.'),
                        SizedBox(height: 4),
                        Text('Tarife eklemek için Yönetici Paneli\'ni kullanın.',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                )
              else
                ActiveTariffCard(tariff: active.first, readOnly: true),

              // ── Tariff history ───────────────────────────────────
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
    );
  }
}

// ─── Active tariff card ───────────────────────────────────────────────────────

class ActiveTariffCard extends ConsumerWidget {
  const ActiveTariffCard({super.key, required this.tariff, this.readOnly = false});

  final Tariff tariff;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final since = DateFormat('dd MMMM yyyy', 'tr_TR').format(tariff.validFrom);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('AKTİF',
                      style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(tariff.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
                if (!readOnly)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Düzenle',
                    onPressed: () => showTariffFormSheet(
                      context,
                      existingTariff: tariff,
                      isEditing: true,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text('$since tarihinden geçerli',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey)),
            const Divider(height: 20),
            TariffBracketsDisplay(tariff: tariff),
          ],
        ),
      ),
    );
  }
}

// ─── History tile ─────────────────────────────────────────────────────────────

class HistoryTariffTile extends ConsumerStatefulWidget {
  const HistoryTariffTile({super.key, required this.tariff});

  final Tariff tariff;

  @override
  ConsumerState<HistoryTariffTile> createState() => _HistoryTariffTileState();
}

class _HistoryTariffTileState extends ConsumerState<HistoryTariffTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.tariff;
    final from = DateFormat('dd.MM.yyyy').format(t.validFrom);
    final to = t.validTo != null
        ? DateFormat('dd.MM.yyyy').format(t.validTo!)
        : '—';

    return Card(
      color: Colors.grey.shade50,
      child: Column(
        children: [
          ListTile(
            title: Text(t.name),
            subtitle: Text('$from – $to'),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
              child: TariffBracketsDisplay(tariff: t),
            ),
        ],
      ),
    );
  }
}
