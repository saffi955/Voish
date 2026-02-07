import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mini_app_scaffold.dart';

class OffersApp extends StatelessWidget {
  const OffersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MiniAppScaffold(
      title: "Exclusive Offers",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lucky Draw Banner
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.purple.shade700, Colors.deepPurple]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                      right: -20,
                      top: -20,
                      child: const Icon(Icons.card_giftcard,
                          size: 150, color: Colors.white10)),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Daily Lucky Draw",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text("Win a new iPhone 15 Pro!",
                            style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.purple),
                          child: const Text("Enter Now"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text("My Coupons",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildCouponCard(
                "Food", "50% OFF", "Use code: YUMMY50", Colors.orange),
            _buildCouponCard(
                "Ride", "Free Ride", "Use code: GOFREE", Colors.blue),
            _buildCouponCard("Shopping", "\$10 Cashback", "Use code: SHOP10",
                AppTheme.primaryRed),

            const SizedBox(height: 24),
            const Text("Special Collections",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCollectionCard("Summer Sale", Colors.teal),
                  _buildCollectionCard("Black Friday", Colors.black),
                  _buildCollectionCard("Eid Special", Colors.green),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCard(
      String category, String offer, String code, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category,
                  style: TextStyle(
                      color: color, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(offer,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(code,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Icon(Icons.content_copy, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildCollectionCard(String title, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
