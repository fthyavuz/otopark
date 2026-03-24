import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'subscriber_models.dart';
import 'subscriber_providers.dart';
import 'widgets/subscriber_card.dart';
import 'widgets/subscriber_form_sheet.dart';

enum _Filter { all, active, expired }

class SubscriberScreen extends ConsumerStatefulWidget {
  const SubscriberScreen({super.key});

  @override
  ConsumerState<SubscriberScreen> createState() => _SubscriberScreenState();
}

class _SubscriberScreenState extends ConsumerState<SubscriberScreen> {
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final subscribersAsync = ref.watch(allSubscribersProvider);
    final platesAsync = ref.watch(allSubscriberPlatesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Abonmanlar')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showSubscriberFormSheet(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Yeni Abonman'),
      ),
      body: Column(
        children: [
          // ── Filter chips ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SegmentedButton<_Filter>(
              segments: const [
                ButtonSegment(
                    value: _Filter.all,
                    label: Text('Tümü'),
                    icon: Icon(Icons.list)),
                ButtonSegment(
                    value: _Filter.active,
                    label: Text('Aktif'),
                    icon: Icon(Icons.check_circle_outline)),
                ButtonSegment(
                    value: _Filter.expired,
                    label: Text('Süresi Dolmuş'),
                    icon: Icon(Icons.cancel_outlined)),
              ],
              selected: {_filter},
              onSelectionChanged: (s) => setState(() => _filter = s.first),
              style: const ButtonStyle(
                  visualDensity: VisualDensity.compact),
            ),
          ),

          // ── List ─────────────────────────────────────────────
          Expanded(
            child: subscribersAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hata: $e')),
              data: (subs) {
                final allPlates = platesAsync.value ?? [];

                // Build plate map
                final platesMap = <int, List<dynamic>>{};
                for (final p in allPlates) {
                  platesMap.putIfAbsent(p.subscriberId, () => []).add(p);
                }

                // Build combined list
                final items = subs
                    .map((s) => SubscriberWithPlates(
                          subscriber: s,
                          plates: (platesMap[s.id] ?? []).cast(),
                        ))
                    .toList();

                // Apply filter
                final filtered = switch (_filter) {
                  _Filter.all => items,
                  _Filter.active => items
                      .where((i) => i.status != SubStatus.expired)
                      .toList(),
                  _Filter.expired => items
                      .where((i) => i.status == SubStatus.expired)
                      .toList(),
                };

                if (subs.isEmpty) {
                  return const _EmptyState();
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      _filter == _Filter.active
                          ? 'Aktif abonman bulunamadı.'
                          : 'Süresi dolmuş abonman yok.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) =>
                      SubscriberCard(item: filtered[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.card_membership,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('Henüz abonman yok',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Yeni abonman eklemek için + butonuna basın.',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
