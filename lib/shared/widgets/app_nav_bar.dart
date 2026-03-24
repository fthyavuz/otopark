import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({
    super.key,
    required this.child,
    required this.location,
  });

  final Widget child;
  final String location;

  static const _items = [
    (icon: Icons.dashboard, label: 'Ana Sayfa', route: '/'),
    (icon: Icons.directions_car, label: 'Araçlar', route: '/active-cars'),
    (icon: Icons.login, label: 'Giriş', route: '/entry'),
    (icon: Icons.logout, label: 'Çıkış', route: '/exit'),
    (icon: Icons.bar_chart, label: 'Raporlar', route: '/reports'),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _items.indexWhere((e) => e.route == location);
    final idx = selectedIndex < 0 ? 0 : selectedIndex;
    final isTablet = MediaQuery.of(context).size.width >= 600;

    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: idx,
              onDestinationSelected: (i) => context.go(_items[i].route),
              labelType: NavigationRailLabelType.all,
              destinations: _items
                  .map((e) => NavigationRailDestination(
                        icon: Icon(e.icon),
                        label: Text(e.label),
                      ))
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => context.go(_items[i].route),
        destinations: _items
            .map((e) => NavigationDestination(
                  icon: Icon(e.icon),
                  label: e.label,
                ))
            .toList(),
      ),
    );
  }
}
