import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/properties/screens/property_search_screen.dart';
import '../features/properties/screens/property_details_screen.dart';
import '../features/properties/screens/saved_properties_screen.dart';
import '../features/calculators/screens/calculator_tabs_screen.dart';
import '../features/auth/screens/otp_verification_screen.dart';
import '../features/appointments/screens/book_viewing_screen.dart';
import '../features/appointments/screens/appointments_screen.dart';
import '../features/portal/screens/portal_screen.dart';
import '../features/properties/models/property_model.dart';
import '../features/chatbot/screens/chat_screen.dart';
import '../features/chatbot/widgets/chat_fab.dart';

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
          // Browse Properties (Home)
          GoRoute(
            path: '/',
            builder: (context, state) => const PropertySearchScreen(),
          ),

          // Calculators
          GoRoute(
            path: '/calculators',
            builder: (context, state) => const CalculatorTabsScreen(),
          ),

          // Portal
          GoRoute(
            path: '/portal',
            builder: (context, state) => const PortalScreen(),
          ),
        ],
      ),

      // Property Details (outside bottom nav)
      GoRoute(
        path: '/property/:zpid',
        builder: (context, state) {
          final zpid = state.pathParameters['zpid']!;
          final property = state.extra as Property?;
          return PropertyDetailsScreen(zpid: zpid, property: property);
        },
      ),

      // OTP Verification
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) => const OtpVerificationScreen(),
      ),

      // Saved Properties
      GoRoute(
        path: '/saved-properties',
        builder: (context, state) => const SavedPropertiesScreen(),
      ),

      // Appointments
      GoRoute(
        path: '/appointments',
        builder: (context, state) => const AppointmentsScreen(),
      ),

      // Book Viewing
      GoRoute(
        path: '/book-viewing',
        builder: (context, state) {
          final property = state.extra as Property;
          return BookViewingScreen(property: property);
        },
      ),

      // Chatbot
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatScreen(),
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
      floatingActionButton: const ChatFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
