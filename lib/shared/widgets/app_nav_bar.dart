import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key, required this.child});

  final Widget child;

  static const _items = [
    (icon: Icons.dashboard, label: 'Ana Sayfa', route: '/'),
    (icon: Icons.directions_car, label: 'Araçlar', route: '/active-cars'),
    (icon: Icons.login, label: 'Giriş', route: '/entry'),
    (icon: Icons.logout, label: 'Çıkış', route: '/exit'),
    (icon: Icons.bar_chart, label: 'Raporlar', route: '/reports'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _items.indexWhere((e) => e.route == location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
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
