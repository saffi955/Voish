import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mini_app_scaffold.dart';

class ShoppingApp extends StatefulWidget {
  const ShoppingApp({super.key});

  @override
  State<ShoppingApp> createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  @override
  Widget build(BuildContext context) {
    return MiniAppScaffold(
      title: "Voish Shopping",
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showProductDetails(context, index),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: const Center(child: Icon(Icons.image, color: Colors.white24, size: 40)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Item ${index + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text("\$${(index + 1) * 20}.99", style: const TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showProductDetails(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Product ${index + 1} Details", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("High quality product with amazing features. Lorem ipsum dolor sit amet.", style: TextStyle(color: Colors.white70)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Purchase Successful!")));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRed),
                  child: const Text("Buy Now"),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
