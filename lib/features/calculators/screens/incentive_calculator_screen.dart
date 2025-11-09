import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/mortgage_calculation.dart';
import '../../../core/utils/formatters.dart';

class IncentiveCalculatorScreen extends StatefulWidget {
  const IncentiveCalculatorScreen({super.key});

  @override
  State<IncentiveCalculatorScreen> createState() => _IncentiveCalculatorScreenState();
}

class _IncentiveCalculatorScreenState extends State<IncentiveCalculatorScreen> {
  final _homePriceController = TextEditingController(text: '500000');
  final _incomeController = TextEditingController(text: '80000');
  bool _isFirstTimeBuyer = true;

  IncentiveCalculation? _calculation;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _homePriceController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  void _calculate() {
    final homePrice = double.tryParse(_homePriceController.text) ?? 0;
    final annualIncome = double.tryParse(_incomeController.text) ?? 0;

    if (homePrice > 0 && annualIncome > 0) {
      setState(() {
        _calculation = IncentiveCalculation(
          homePrice: homePrice,
          annualIncome: annualIncome,
          isFirstTimeBuyer: _isFirstTimeBuyer,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BC First-Time Home Buyer Incentive'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'About this program',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The BC Home Owner Mortgage and Equity Partnership helps first-time buyers with down payments. The province provides up to 5% of the purchase price (max \$37,500).',
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // First Time Buyer Toggle
            SwitchListTile(
              title: const Text('I am a first-time home buyer'),
              subtitle: const Text('Required for this program'),
              value: _isFirstTimeBuyer,
              onChanged: (value) {
                setState(() => _isFirstTimeBuyer = value);
                _calculate();
              },
            ),

            const SizedBox(height: 16),

            // Home Price
            TextField(
              controller: _homePriceController,
              decoration: const InputDecoration(
                labelText: 'Home Price',
                prefixText: '\$',
                helperText: 'Maximum \$750,000 for this program',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => _calculate(),
            ),

            const SizedBox(height: 16),

            // Annual Income
            TextField(
              controller: _incomeController,
              decoration: const InputDecoration(
                labelText: 'Annual Household Income',
                prefixText: '\$',
                helperText: 'Combined income before taxes',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => _calculate(),
            ),

            const SizedBox(height: 32),

            // Results
            if (_calculation != null) ...[
              // Eligibility Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _calculation!.isEligible
                      ? Colors.green[50]
                      : Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _calculation!.isEligible
                        ? Colors.green[300]!
                        : Colors.orange[300]!,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _calculation!.isEligible ? Icons.check_circle : Icons.warning,
                      size: 48,
                      color: _calculation!.isEligible
                          ? Colors.green[700]
                          : Colors.orange[700],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _calculation!.isEligible
                          ? 'You may be eligible!'
                          : 'You may not be eligible',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _calculation!.isEligible
                            ? Colors.green[700]
                            : Colors.orange[700],
                      ),
                    ),
                    if (_calculation!.ineligibilityReason != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _calculation!.ineligibilityReason!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              if (_calculation!.isEligible) ...[
                // Incentive Amount
                _ResultCard(
                  title: 'Estimated Incentive Amount',
                  value: Formatters.formatCurrency(_calculation!.incentiveAmount),
                  color: Theme.of(context).primaryColor,
                  subtitle: '5% of purchase price, up to \$37,500',
                ),

                const SizedBox(height: 16),

                // Reduced Down Payment
                _ResultCard(
                  title: 'Your Down Payment After Incentive',
                  value: Formatters.formatCurrency(_calculation!.downPaymentAfterIncentive),
                  subtitle: 'With minimum 5% down payment',
                ),

                const SizedBox(height: 16),

                // Reduced Mortgage Amount
                _ResultCard(
                  title: 'Reduced Mortgage Amount',
                  value: Formatters.formatCurrency(_calculation!.mortgageAmountAfterIncentive),
                  subtitle: 'Loan amount after incentive',
                ),

                const SizedBox(height: 24),

                // Program Details Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(),
                        _DetailRow(
                          icon: Icons.home,
                          title: 'Property must be in BC',
                        ),
                        _DetailRow(
                          icon: Icons.person,
                          title: 'Must be first-time home buyer',
                        ),
                        _DetailRow(
                          icon: Icons.account_balance,
                          title: 'Loan is interest-free for 5 years',
                        ),
                        _DetailRow(
                          icon: Icons.calendar_today,
                          title: 'Must be repaid when you sell or after 25 years',
                        ),
                        _DetailRow(
                          icon: Icons.trending_up,
                          title: 'Repayment amount varies with home value',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // More Info Button
                OutlinedButton.icon(
                  onPressed: () {
                    // Could open web view or external link
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Visit bchousing.org for full program details'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Learn More About This Program'),
                ),
              ],
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
  final String? subtitle;
  final Color? color;

  const _ResultCard({
    required this.title,
    required this.value,
    this.subtitle,
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
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const _DetailRow({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title),
          ),
        ],
      ),
    );
  }
}
