import 'dart:math';
import 'package:equatable/equatable.dart';

class MortgageCalculation extends Equatable {
  final double homePrice;
  final double downPayment;
  final double interestRate;
  final int amortizationYears;
  final String paymentFrequency; // 'monthly', 'bi-weekly', 'weekly'

  const MortgageCalculation({
    required this.homePrice,
    required this.downPayment,
    required this.interestRate,
    required this.amortizationYears,
    this.paymentFrequency = 'monthly',
  });

  // Calculated values
  double get loanAmount => homePrice - downPayment;
  double get downPaymentPercentage => (downPayment / homePrice) * 100;

  double get monthlyPayment => _calculatePayment(12);
  double get biWeeklyPayment => _calculatePayment(26);
  double get weeklyPayment => _calculatePayment(52);

  double get totalInterest {
    final totalPaid = monthlyPayment * amortizationYears * 12;
    return totalPaid - loanAmount;
  }

  double get totalCost => homePrice + totalInterest;

  double _calculatePayment(int paymentsPerYear) {
    final principal = loanAmount;
    final annualRate = interestRate / 100;
    final periodicRate = annualRate / paymentsPerYear;
    final numberOfPayments = amortizationYears * paymentsPerYear;

    if (periodicRate == 0) {
      return principal / numberOfPayments;
    }

    return principal *
        (periodicRate * pow(1 + periodicRate, numberOfPayments)) /
        (pow(1 + periodicRate, numberOfPayments) - 1);
  }

  MortgageCalculation copyWith({
    double? homePrice,
    double? downPayment,
    double? interestRate,
    int? amortizationYears,
    String? paymentFrequency,
  }) {
    return MortgageCalculation(
      homePrice: homePrice ?? this.homePrice,
      downPayment: downPayment ?? this.downPayment,
      interestRate: interestRate ?? this.interestRate,
      amortizationYears: amortizationYears ?? this.amortizationYears,
      paymentFrequency: paymentFrequency ?? this.paymentFrequency,
    );
  }

  @override
  List<Object?> get props => [
        homePrice,
        downPayment,
        interestRate,
        amortizationYears,
        paymentFrequency,
      ];
}

class IncentiveCalculation extends Equatable {
  final double homePrice;
  final double annualIncome;
  final bool isFirstTimeBuyer;

  const IncentiveCalculation({
    required this.homePrice,
    required this.annualIncome,
    required this.isFirstTimeBuyer,
  });

  // BC Home Owner Mortgage and Equity Partnership
  double get incentiveAmount {
    if (!isEligible) return 0;
    final amount = homePrice * 0.05; // 5% of purchase price
    return amount > 37500 ? 37500 : amount; // Max $37,500
  }

  double get downPaymentAfterIncentive {
    final minimumDown = homePrice * 0.05; // 5% minimum
    return minimumDown - incentiveAmount;
  }

  double get mortgageAmountAfterIncentive {
    return homePrice - (homePrice * 0.05); // After 5% down payment
  }

  bool get isEligible {
    if (!isFirstTimeBuyer) return false;
    if (homePrice > 750000) return false; // Maximum purchase price
    if (annualIncome > 150000) return false; // Income limit (simplified)
    return true;
  }

  String? get ineligibilityReason {
    if (!isFirstTimeBuyer) return 'Must be a first-time home buyer';
    if (homePrice > 750000) return 'Home price exceeds \$750,000 maximum';
    if (annualIncome > 150000) return 'Annual income exceeds program limit';
    return null;
  }

  IncentiveCalculation copyWith({
    double? homePrice,
    double? annualIncome,
    bool? isFirstTimeBuyer,
  }) {
    return IncentiveCalculation(
      homePrice: homePrice ?? this.homePrice,
      annualIncome: annualIncome ?? this.annualIncome,
      isFirstTimeBuyer: isFirstTimeBuyer ?? this.isFirstTimeBuyer,
    );
  }

  @override
  List<Object?> get props => [homePrice, annualIncome, isFirstTimeBuyer];
}
