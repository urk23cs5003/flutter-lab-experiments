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
      title: 'Product Search',
      home: const ProductSearchPage(),
    );
  }
}

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final TextEditingController searchController = TextEditingController();

  String searchText = '';
  String selectedCategory = 'All Categories';

 final List<Map<String, dynamic>> products = [
  {
    'name': 'Laptop',
    'category': 'Electronics',
    'price': '₹55,000',
    'icon': Icons.laptop,
  },
  {
    'name': 'Smartphone',
    'category': 'Electronics',
    'price': '₹25,000',
    'icon': Icons.smartphone,
  },
  {
    'name': 'Headphones',
    'category': 'Accessories',
    'price': '₹3,000',
    'icon': Icons.headphones,
  },
  {
    'name': 'Smart Watch',
    'category': 'Accessories',
    'price': '₹5,000',
    'icon': Icons.watch,
  },
  {
    'name': 'Camera',
    'category': 'Electronics',
    'price': '₹40,000',
    'icon': Icons.camera_alt,
  },
  {
    'name': 'Tablet',
    'category': 'Electronics',
    'price': '₹20,000',
    'icon': Icons.tablet,
  },
  {
    'name': 'Keyboard',
    'category': 'Accessories',
    'price': '₹2,000',
    'icon': Icons.keyboard,
  },
  {
    'name': 'Mouse',
    'category': 'Accessories',
    'price': '₹1,000',
    'icon': Icons.mouse,
  },
  {
    'name': 'Television',
    'category': 'Electronics',
    'price': '₹35,000',
    'icon': Icons.tv,
  },
  {
    'name': 'Speaker',
    'category': 'Audio',
    'price': '₹4,000',
    'icon': Icons.speaker,
  },
  {
    'name': 'Gaming Console',
    'category': 'Gaming',
    'price': '₹45,000',
    'icon': Icons.gamepad,
  },
  {
    'name': 'Printer',
    'category': 'Office',
    'price': '₹12,000',
    'icon': Icons.print,
  },
  {
    'name': 'Monitor',
    'category': 'Electronics',
    'price': '₹18,000',
    'icon': Icons.monitor,
  },
  {
    'name': 'Microphone',
    'category': 'Audio',
    'price': '₹6,000',
    'icon': Icons.mic,
  },
  {
    'name': 'Router',
    'category': 'Networking',
    'price': '₹3,500',
    'icon': Icons.router,
  },
];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProducts = products.where((product) {
  final matchesSearch = product['name']
      .toString()
      .toLowerCase()
      .contains(searchText.toLowerCase());

  final matchesCategory = selectedCategory == 'All Categories' ||
      product['category'] == selectedCategory;

  return matchesSearch && matchesCategory;
}).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search products',
                hintText: 'Enter product name',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();

                    setState(() {
                      searchText = '';
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            const SizedBox(height: 15),

DropdownButtonFormField<String>(
  value: selectedCategory,
  decoration: const InputDecoration(
    labelText: 'Filter by Category',
    border: OutlineInputBorder(),
  ),
  items: const [
    DropdownMenuItem(
      value: 'All Categories',
      child: Text('All Categories'),
    ),
    DropdownMenuItem(
      value: 'Electronics',
      child: Text('Electronics'),
    ),
    DropdownMenuItem(
      value: 'Accessories',
      child: Text('Accessories'),
    ),
    DropdownMenuItem(
      value: 'Audio',
      child: Text('Audio'),
    ),
    DropdownMenuItem(
      value: 'Gaming',
      child: Text('Gaming'),
    ),
    DropdownMenuItem(
      value: 'Office',
      child: Text('Office'),
    ),
    DropdownMenuItem(
      value: 'Networking',
      child: Text('Networking'),
    ),
  ],
  onChanged: (value) {
    setState(() {
      selectedCategory = value!;
    });
  },
),

            const SizedBox(height: 20),

            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];

                        return ProductCard(
                          icon: product['icon'],
                          name: product['name'],
                          category: product['category'],
                          price: product['price'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String category;
  final String price;

  const ProductCard({
    super.key,
    required this.icon,
    required this.name,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          size: 45,
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(category),
        trailing: Text(
          price,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}