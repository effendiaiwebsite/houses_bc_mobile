import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/properties/screens/property_search_screen.dart';
import '../features/properties/screens/property_details_screen.dart';
import '../features/calculators/screens/mortgage_calculator_screen.dart';
import '../features/auth/screens/otp_verification_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // Main navigation with bottom nav
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          // Browse Properties
          GoRoute(
            path: '/',
            builder: (context, state) => const PropertySearchScreen(),
          ),

          // Calculators
          GoRoute(
            path: '/calculators',
            builder: (context, state) => const MortgageCalculatorScreen(),
          ),

          // Portal (placeholder)
          GoRoute(
            path: '/portal',
            builder: (context, state) => const PortalPlaceholderScreen(),
          ),
        ],
      ),

      // Property Details
      GoRoute(
        path: '/property/:zpid',
        builder: (context, state) {
          final zpid = state.pathParameters['zpid']!;
          return PropertyDetailsScreen(zpid: zpid);
        },
      ),

      // OTP Verification
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
    ],
  );
});

/// Main scaffold with bottom navigation
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(location),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Portal',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/calculators')) return 1;
    if (location.startsWith('/portal')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/calculators');
        break;
      case 2:
        context.go('/portal');
        break;
    }
  }
}

/// Placeholder portal screen
class PortalPlaceholderScreen extends StatelessWidget {
  const PortalPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Portal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Client Portal',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Saved properties and appointments will appear here after logging in.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.push('/otp-verification');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
