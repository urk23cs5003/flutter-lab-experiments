
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Budget Calculator',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const BudgetCalculator(),
    );
  }
}

class BudgetCalculator extends StatefulWidget {
  const BudgetCalculator({super.key});

  @override
  State<BudgetCalculator> createState() =>
      _BudgetCalculatorState();
}

class _BudgetCalculatorState extends State<BudgetCalculator> {
  final TextEditingController incomeController =
      TextEditingController();

  final TextEditingController expensesController =
      TextEditingController();

  double? balance;
  String financialStatus = '';

  void calculateBudget() {
    final double? income =
        double.tryParse(incomeController.text.trim());

    final double? expenses =
        double.tryParse(expensesController.text.trim());

    if (income == null ||
        expenses == null ||
        !income.isFinite ||
        !expenses.isFinite ||
        income < 0 ||
        expenses < 0 ||
        (income == 0 && expenses == 0)) {
      setState(() {
        balance = null;
        financialStatus = 'Enter valid income and expenses';
      });
      return;
    }

    setState(() {
      balance = income - expenses;

      if (balance! > 0) {
        financialStatus = 'You have savings!';
      } else if (balance! == 0) {
        financialStatus = 'Your budget is balanced.';
      } else {
        financialStatus = 'Your expenses exceed your income.';
      }
    });
  }

  @override
  void dispose() {
    incomeController.dispose();
    expensesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Budget Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: Colors.teal,
            ),

            const SizedBox(height: 25),

            TextField(
              controller: incomeController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monthly Income (₹)',
                prefixIcon: Icon(Icons.currency_rupee),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: expensesController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monthly Expenses (₹)',
                prefixIcon: Icon(Icons.shopping_cart),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: calculateBudget,
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'Calculate Budget',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (financialStatus.isNotEmpty)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        financialStatus,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: balance == null
                              ? Colors.orange
                              : balance! < 0
                                  ? Colors.red
                                  : Colors.teal,
                        ),
                      ),

                      if (balance != null) ...[
                        const SizedBox(height: 15),
                        const Text('Remaining Balance'),
                        const SizedBox(height: 8),
                        Text(
                          '₹${balance!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: balance! < 0
                                ? Colors.red
                                : Colors.teal,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
