import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fruit List',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fruit List'),
        ),

        // ListView displays all fruit cards
        body: ListView(
          children: const [
            FruitCard(
              emoji: '🍎',
              name: 'Apple',
              description: 'Red and sweet',
            ),

            FruitCard(
              emoji: '🍌',
              name: 'Banana',
              description: 'Yellow and tasty',
            ),

            FruitCard(
              emoji: '🍊',
              name: 'Orange',
              description: 'Juicy and healthy',
            ),

            FruitCard(
              emoji: '🍇',
              name: 'Grapes',
              description: 'Small and sweet',
            ),

            FruitCard(
              emoji: '🥭',
              name: 'Mango',
              description: 'King of fruits',
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable custom widget
class FruitCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String description;

  const FruitCard({
    super.key,
    required this.emoji,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(
                fontSize: 35,
              ),
            ),

            const SizedBox(width: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}