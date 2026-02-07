import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mini_app_scaffold.dart';

class WalletApp extends StatelessWidget {
  const WalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MiniAppScaffold(
      title: "Voish Wallet",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Crypto/Balance Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade900, Colors.deepPurple.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 15,
                      offset: Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Balance",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  const Text("\$12,450.00",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(Icons.arrow_upward, "Send"),
                      _buildActionButton(Icons.arrow_downward, "Receive"),
                      _buildActionButton(Icons.swap_horiz, "Swap"),
                      _buildActionButton(Icons.qr_code_scanner, "Scan"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Assets
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Assets",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            _buildAssetTile(
                "Bitcoin", "BTC", "\$42,000", "+2.4%", Colors.orange),
            _buildAssetTile("Ethereum", "ETH", "\$2,200", "-1.1%", Colors.blue),
            _buildAssetTile(
                "Voish Coin", "VSH", "\$0.45", "+15.0%", AppTheme.primaryRed),
            _buildAssetTile("Tether", "USDT", "\$1.00", "0.0%", Colors.green),

            const SizedBox(height: 30),
            // Transactions
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Recent Transactions",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            _buildTransactionTile("Starbucks Coffee", "-\$5.50", "Today"),
            _buildTransactionTile("Received BTC", "+\$500.00", "Yesterday"),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildAssetTile(
      String name, String symbol, String price, String change, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(symbol[0],
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(symbol,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(change,
                  style: TextStyle(
                      color: change.startsWith('+')
                          ? Colors.green
                          : (change == '0.0%' ? Colors.grey : Colors.red),
                      fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(String title, String amount, String date) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppTheme.backgroundBlack,
            borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.receipt, color: Colors.grey),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle:
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: Text(amount,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
