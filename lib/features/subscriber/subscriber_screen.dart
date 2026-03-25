import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'subscriber_models.dart';
import 'subscriber_providers.dart';
import 'widgets/subscriber_card.dart';
import 'widgets/subscriber_form_sheet.dart';

class SubscriberScreen extends ConsumerWidget {
  const SubscriberScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscribersAsync = ref.watch(allSubscribersProvider);
    final platesAsync = ref.watch(allSubscriberPlatesProvider);
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Abonmanlar'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calendar_month), text: 'Aylık'),
              Tab(icon: Icon(Icons.today), text: 'Günlük'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showSubscriberFormSheet(context),
          icon: const Icon(Icons.person_add),
          label: const Text('Yeni Abonman'),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: isTablet ? 720 : double.infinity),
            child: subscribersAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hata: $e')),
              data: (subs) {
                final allPlates = platesAsync.value ?? [];

                final platesMap = <int, List<dynamic>>{};
                for (final p in allPlates) {
                  platesMap.putIfAbsent(p.subscriberId, () => []).add(p);
                }

                final items = subs
                    .map((s) => SubscriberWithPlates(
                          subscriber: s,
                          plates: (platesMap[s.id] ?? []).cast(),
                        ))
                    .toList();

                final monthlyItems =
                    items.where((i) => i.type == SubType.monthly).toList();
                final dailyItems =
                    items.where((i) => i.type == SubType.daily).toList();

                return TabBarView(
                  children: [
                    _SubscriberList(
                      items: monthlyItems,
                      emptyMessage: 'Henüz aylık abonman yok.',
                      showFilter: true,
                    ),
                    _SubscriberList(
                      items: dailyItems,
                      emptyMessage: 'Henüz günlük abone kaydı yok.',
                      showFilter: false,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Subscriber list tab ──────────────────────────────────────────────────────

enum _Filter { all, active, expired }

class _SubscriberList extends StatefulWidget {
  const _SubscriberList({
    required this.items,
    required this.emptyMessage,
    required this.showFilter,
  });

  final List<SubscriberWithPlates> items;
  final String emptyMessage;
  final bool showFilter;

  @override
  State<_SubscriberList> createState() => _SubscriberListState();
}

class _SubscriberListState extends State<_SubscriberList> {
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return _EmptyState(message: widget.emptyMessage);
    }

    final filtered = switch (_filter) {
      _Filter.all => widget.items,
      _Filter.active => widget.items
          .where((i) => i.status != SubStatus.expired)
          .toList(),
      _Filter.expired =>
        widget.items.where((i) => i.status == SubStatus.expired).toList(),
    };

    return Column(
      children: [
        if (widget.showFilter)
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
              onSelectionChanged: (s) =>
                  setState(() => _filter = s.first),
              style:
                  const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    _filter == _Filter.active
                        ? 'Aktif abonman bulunamadı.'
                        : 'Süresi dolmuş abonman yok.',
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) =>
                      SubscriberCard(item: filtered[i]),
                ),
        ),
      ],
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.card_membership,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message,
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
