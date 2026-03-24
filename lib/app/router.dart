import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/entry/entry_screen.dart';
import '../features/exit/exit_screen.dart';
import '../features/active_cars/active_cars_screen.dart';
import '../features/tariff/tariff_screen.dart';
import '../features/subscriber/subscriber_screen.dart';
import '../features/reports/reports_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/entry',
      name: 'entry',
      builder: (context, state) => const EntryScreen(),
    ),
    GoRoute(
      path: '/exit',
      name: 'exit',
      // extra: String? — pre-fills the plate from active-cars tap
      builder: (context, state) =>
          ExitScreen(prefilledPlate: state.extra as String?),
    ),
    GoRoute(
      path: '/active-cars',
      name: 'active_cars',
      builder: (context, state) => const ActiveCarsScreen(),
    ),
    GoRoute(
      path: '/tariff',
      name: 'tariff',
      builder: (context, state) => const TariffScreen(),
    ),
    GoRoute(
      path: '/subscribers',
      name: 'subscribers',
      builder: (context, state) => const SubscriberScreen(),
    ),
    GoRoute(
      path: '/reports',
      name: 'reports',
      builder: (context, state) => const ReportsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Sayfa bulunamadı: ${state.error}')),
  ),
);
