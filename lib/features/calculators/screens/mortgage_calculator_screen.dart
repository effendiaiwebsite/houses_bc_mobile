import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/mortgage_calculation.dart';
import '../../../core/utils/formatters.dart';

class MortgageCalculatorScreen extends StatefulWidget {
  const MortgageCalculatorScreen({super.key});

  @override
  State<MortgageCalculatorScreen> createState() => _MortgageCalculatorScreenState();
}

class _MortgageCalculatorScreenState extends State<MortgageCalculatorScreen> {
  final _homePriceController = TextEditingController(text: '500000');
  final _downPaymentController = TextEditingController(text: '100000');
  double _interestRate = 5.0;
  int _amortizationYears = 25;

  MortgageCalculation? _calculation;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _homePriceController.dispose();
    _downPaymentController.dispose();
    super.dispose();
  }

  void _calculate() {
    final homePrice = double.tryParse(_homePriceController.text) ?? 0;
    final downPayment = double.tryParse(_downPaymentController.text) ?? 0;

    if (homePrice > 0 && downPayment > 0 && downPayment <= homePrice) {
      setState(() {
        _calculation = MortgageCalculation(
          homePrice: homePrice,
          downPayment: downPayment,
          interestRate: _interestRate,
          amortizationYears: _amortizationYears,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mortgage Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Home Price
            TextField(
              controller: _homePriceController,
              decoration: const InputDecoration(
                labelText: 'Home Price',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => _calculate(),
            ),

            const SizedBox(height: 16),

            // Down Payment
            TextField(
              controller: _downPaymentController,
              decoration: const InputDecoration(
                labelText: 'Down Payment',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => _calculate(),
            ),

            const SizedBox(height: 24),

            // Interest Rate Slider
            Text('Interest Rate: ${_interestRate.toStringAsFixed(2)}%'),
            Slider(
              value: _interestRate,
              min: 1.0,
              max: 10.0,
              divisions: 90,
              label: '${_interestRate.toStringAsFixed(2)}%',
              onChanged: (value) {
                setState(() => _interestRate = value);
                _calculate();
              },
            ),

            const SizedBox(height: 16),

            // Amortization Slider
            Text('Amortization: $_amortizationYears years'),
            Slider(
              value: _amortizationYears.toDouble(),
              min: 5,
              max: 30,
              divisions: 25,
              label: '$_amortizationYears years',
              onChanged: (value) {
                setState(() => _amortizationYears = value.toInt());
                _calculate();
              },
            ),

            const SizedBox(height: 32),

            // Results
            if (_calculation != null) ...[
              _ResultCard(
                title: 'Monthly Payment',
                value: Formatters.formatCurrency(_calculation!.monthlyPayment),
                color: Theme.of(context).primaryColor,
              ),

              const SizedBox(height: 16),

              _ResultCard(
                title: 'Bi-Weekly Payment',
                value: Formatters.formatCurrency(_calculation!.biWeeklyPayment),
              ),

              const SizedBox(height: 16),

              _ResultCard(
                title: 'Total Interest',
                value: Formatters.formatCurrency(_calculation!.totalInterest),
              ),

              const SizedBox(height: 16),

              _ResultCard(
                title: 'Total Cost',
                value: Formatters.formatCurrency(_calculation!.totalCost),
              ),

              const SizedBox(height: 24),

              // Summary Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Divider(),
                      _SummaryRow('Home Price', Formatters.formatCurrency(_calculation!.homePrice)),
                      _SummaryRow('Down Payment', Formatters.formatCurrency(_calculation!.downPayment)),
                      _SummaryRow('Loan Amount', Formatters.formatCurrency(_calculation!.loanAmount)),
                      _SummaryRow('Interest Rate', '${_calculation!.interestRate.toStringAsFixed(2)}%'),
                      _SummaryRow('Amortization', '${_calculation!.amortizationYears} years'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const _ResultCard({
    required this.title,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
