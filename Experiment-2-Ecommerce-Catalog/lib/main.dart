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
      title: 'E-Commerce Catalog',
      home: const ProductCatalog(),
    );
  }
}

class ProductCatalog extends StatelessWidget {
  const ProductCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Commerce Catalog'),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {

          // Change number of columns according to screen width
          int columns;

          if (constraints.maxWidth >= 1000) {
            columns = 4;
          } else if (constraints.maxWidth >= 600) {
            columns = 2;
          } else {
            columns = 1;
          }

          return GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,

            children: const [
              ProductCard(
                icon: Icons.laptop,
                name: 'Laptop',
                price: '₹55,000',
              ),

              ProductCard(
                icon: Icons.smartphone,
                name: 'Smartphone',
                price: '₹25,000',
              ),

              ProductCard(
                icon: Icons.headphones,
                name: 'Headphones',
                price: '₹3,000',
              ),

              ProductCard(
                icon: Icons.watch,
                name: 'Smart Watch',
                price: '₹5,000',
              ),
              ProductCard(
  icon: Icons.camera_alt,
  name: 'Camera',
  price: '₹40,000',
),
            ],
          );
        },
      ),
    );
  }
}

// Reusable custom product widget
class ProductCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String price;

  const ProductCard({
    super.key,
    required this.icon,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
            ),

            const SizedBox(height: 15),

            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              price,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}