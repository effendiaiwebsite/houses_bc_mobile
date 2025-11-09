import 'package:flutter/material.dart';
import 'mortgage_calculator_screen.dart';
import 'incentive_calculator_screen.dart';

class CalculatorTabsScreen extends StatelessWidget {
  const CalculatorTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calculators'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.calculate),
                text: 'Mortgage',
              ),
              Tab(
                icon: Icon(Icons.home_work),
                text: 'BC Incentive',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MortgageCalculatorScreen(),
            IncentiveCalculatorScreen(),
          ],
        ),
      ),
    );
  }
}
