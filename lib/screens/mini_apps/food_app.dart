import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mini_app_scaffold.dart';

class FoodApp extends StatefulWidget {
  const FoodApp({super.key});
  @override
  State<FoodApp> createState() => _FoodAppState();
}

class _FoodAppState extends State<FoodApp> {
  int _cartCount = 0;

  @override
  Widget build(BuildContext context) {
    return MiniAppScaffold(
      title: "Voish Food",
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            color: AppTheme.surfaceDark,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: const Center(child: Icon(Icons.fastfood, size: 50, color: Colors.white24)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Restaurant ${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const Text("Burgers • Fast Food • \$\$", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Zinger Burger Combo", style: TextStyle(color: Colors.white)),
                          ElevatedButton(
                            onPressed: () {
                              setState(() => _cartCount++);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to Cart")));
                            },
                             style: ElevatedButton.styleFrom(
                               backgroundColor: AppTheme.primaryRed,
                               minimumSize: const Size(80, 30),
                               padding: EdgeInsets.zero,
                             ),
                            child: const Text("Add"),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _cartCount > 0 
        ? FloatingActionButton.extended(
            onPressed: () {
              // Mock Checkout
              showDialog(context: context, builder: (_) => AlertDialog(
                backgroundColor: AppTheme.surfaceDark,
                title: const Text("Checkout", style: TextStyle(color: Colors.white)),
                content: const Text("Your order has been placed successfully!", style: TextStyle(color: Colors.white)),
                actions: [TextButton(onPressed: () {
                   setState(() => _cartCount = 0);
                   Navigator.pop(context);
                }, child: const Text("OK"))],
              ));
            },
            label: Text("Checkout ($_cartCount)"),
            icon: const Icon(Icons.shopping_cart),
            backgroundColor: AppTheme.primaryRed,
          )
        : null,
    );
  }
}
