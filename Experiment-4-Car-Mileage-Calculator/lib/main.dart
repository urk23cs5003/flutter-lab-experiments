
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
      title: 'Car Mileage Calculator',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const MileageCalculator(),
    );
  }
}

class MileageCalculator extends StatefulWidget {
  const MileageCalculator({super.key});

  @override
  State<MileageCalculator> createState() =>
      _MileageCalculatorState();
}

class _MileageCalculatorState
    extends State<MileageCalculator> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _distanceController =
      TextEditingController();

  final TextEditingController _fuelController =
      TextEditingController();

  double? mileage;

  void calculateMileage() {
    if (_formKey.currentState!.validate()) {
      final double distance =
          double.parse(_distanceController.text.trim());

      final double fuel =
          double.parse(_fuelController.text.trim());

      setState(() {
        mileage = distance / fuel;
      });
    } else {
      setState(() {
        mileage = null;
      });
    }
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _fuelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Mileage Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),

              const Icon(
                Icons.directions_car,
                size: 80,
                color: Colors.blue,
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: _distanceController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Distance Travelled (km)',
                  prefixIcon: Icon(Icons.route),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter the distance';
                  }

                  final double? distance =
                      double.tryParse(value.trim());

                  if (distance == null ||
                      !distance.isFinite ||
                      distance <= 0) {
                    return 'Enter a valid distance greater than 0';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _fuelController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Fuel Consumed (litres)',
                  prefixIcon:
                      Icon(Icons.local_gas_station),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter the fuel consumed';
                  }

                  final double? fuel =
                      double.tryParse(value.trim());

                  if (fuel == null ||
                      !fuel.isFinite ||
                      fuel <= 0) {
                    return 'Enter fuel greater than 0';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: calculateMileage,
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Calculate Mileage',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              if (mileage != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Your Car Mileage',
                          style: TextStyle(fontSize: 18),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          '${mileage!.toStringAsFixed(2)} km/litre',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
