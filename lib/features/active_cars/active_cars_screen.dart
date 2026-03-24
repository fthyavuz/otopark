import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/utils/plate_input_formatter.dart';
import '../../shared/utils/plate_validator.dart';
import 'active_cars_providers.dart';
import 'widgets/car_tile.dart';

class ActiveCarsScreen extends ConsumerStatefulWidget {
  const ActiveCarsScreen({super.key});

  @override
  ConsumerState<ActiveCarsScreen> createState() => _ActiveCarsScreenState();
}

class _ActiveCarsScreenState extends ConsumerState<ActiveCarsScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carsAsync = ref.watch(insideCarsProvider);

    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: carsAsync.when(
          loading: () => const Text('İçerideki Araçlar'),
          error: (_, __) => const Text('İçerideki Araçlar'),
          data: (cars) => Text('İçerideki Araçlar (${cars.length})'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Araç Girişi',
            onPressed: () => context.go('/entry'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isTablet ? 720 : double.infinity),
          child: Column(
        children: [
          // ── Search bar ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Plaka ara... (herhangi bir kısmını yazın)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                isDense: true,
              ),
              textCapitalization: TextCapitalization.characters,
              inputFormatters: const [PlateInputFormatter()],
              onChanged: (v) =>
                  setState(() => _searchQuery = PlateValidator.normalise(v)),
            ),
          ),

          // ── Car list ────────────────────────────────────────
          Expanded(
            child: carsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hata: $e')),
              data: (cars) {
                final q = _searchQuery.replaceAll(' ', '');
                final filtered = q.isEmpty
                    ? cars
                    : cars
                        .where((c) =>
                            c.plate.replaceAll(' ', '').contains(q))
                        .toList();

                if (cars.isEmpty) {
                  return const _EmptyState();
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      '"$_searchQuery" için sonuç bulunamadı.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => CarTile(record: filtered[i]),
                );
              },
            ),
          ),
        ],
          ),
        ),
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
          Icon(Icons.local_parking,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('Otopark boş',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Araç girişi eklemek için + butonuna basın.',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
