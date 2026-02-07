import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mini_app_scaffold.dart';

class EarnApp extends StatelessWidget {
  const EarnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MiniAppScaffold(
      title: "Voish Earn",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Balance Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade700, Colors.orangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Earnings", style: TextStyle(color: Colors.white, fontSize: 14)),
                      SizedBox(height: 8),
                      Text("\$1,250.50", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(Icons.account_balance_wallet, color: Colors.white, size: 40),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Align(alignment: Alignment.centerLeft, child: Text("Available Tasks", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            // Tasks
            _buildTaskTile("Watch Video Ad", "+ \$0.50"),
            _buildTaskTile("Complete Survey", "+ \$2.00"),
            _buildTaskTile("Refer a Friend", "+ \$5.00"),
            _buildTaskTile("Play Game (10 mins)", "+ \$1.50"),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskTile(String title, String reward) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.task_alt, color: AppTheme.primaryRed),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Text("High Priority", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Text(reward, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
