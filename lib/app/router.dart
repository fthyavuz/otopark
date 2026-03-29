import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/entry/entry_screen.dart';
import '../features/exit/exit_screen.dart';
import '../features/exit/exit_models.dart';
import '../features/exit/payment_screen.dart';
import '../features/active_cars/active_cars_screen.dart';
import '../features/tariff/tariff_screen.dart';
import '../features/subscriber/subscriber_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/admin/admin_screen.dart';
import '../features/entry/subscription_payment_screen.dart';
import '../features/registered_vehicles/registered_vehicles_screen.dart';
import '../features/entry/entry_models.dart';
import '../shared/widgets/app_nav_bar.dart';
import '../features/cleaning/cleaning_entry_screen.dart';
import '../features/cleaning/cleaning_service_screen.dart';
import '../features/cleaning/cleaning_payment_screen.dart';
import '../features/cleaning/cleaning_list_screen.dart';
import '../features/cleaning/cleaning_models.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Shell: screens that show the bottom nav bar ──────────────────────
    ShellRoute(
      builder: (context, state, child) =>
          AppNavBar(location: state.uri.toString(), child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/active-cars',
          name: 'active_cars',
          builder: (context, state) => const ActiveCarsScreen(),
        ),
        GoRoute(
          path: '/entry',
          name: 'entry',
          builder: (context, state) => const EntryScreen(),
        ),
        GoRoute(
          path: '/exit',
          name: 'exit',
          // extra: String? — plate pre-filled when tapping from active-cars list
          builder: (context, state) =>
              ExitScreen(prefilledPlate: state.extra as String?),
        ),
        GoRoute(
          path: '/reports',
          name: 'reports',
          builder: (context, state) => const ReportsScreen(),
        ),
      ],
    ),

    // ── Top-level: no bottom nav bar ─────────────────────────────────────
    GoRoute(
      path: '/payment',
      name: 'payment',
      // extra: PaymentData — carries record + tariff + cost result
      builder: (context, state) =>
          PaymentScreen(data: state.extra as PaymentData),
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
      path: '/admin',
      name: 'admin',
      builder: (context, state) => const AdminScreen(),
    ),
    GoRoute(
      path: '/registered-vehicles',
      name: 'registered_vehicles',
      builder: (context, state) => const RegisteredVehiclesScreen(),
    ),
    GoRoute(
      path: '/subscription-payment',
      name: 'subscription_payment',
      builder: (context, state) =>
          SubscriptionPaymentScreen(data: state.extra as SubscriptionPaymentData),
    ),
    GoRoute(
      path: '/cleaning',
      name: 'cleaning',
      builder: (context, state) => const CleaningEntryScreen(),
    ),
    GoRoute(
      path: '/cleaning-service',
      name: 'cleaning_service',
      builder: (context, state) =>
          CleaningServiceScreen(data: state.extra as CleaningEntryData),
    ),
    GoRoute(
      path: '/cleaning-payment',
      name: 'cleaning_payment',
      builder: (context, state) =>
          CleaningPaymentScreen(data: state.extra as CleaningPaymentData),
    ),
    GoRoute(
      path: '/cleaning-list',
      name: 'cleaning_list',
      builder: (context, state) => const CleaningListScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Sayfa bulunamadı: ${state.error}')),
  ),
);
