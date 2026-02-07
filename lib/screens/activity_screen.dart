import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/app_theme.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      appBar: AppBar(
        title: const Text("Activity"),
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.plus, color: AppTheme.primaryRed),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Add Custom Task")));
            },
            tooltip: "Add Custom Task",
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Live Activities",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // Food Order
          _buildActivityCard(
            icon: Icons.fastfood,
            title: "Food Delivery",
            subtitle: "Burger King • Arriving in 15 mins",
            status: "On the way",
            color: Colors.orange,
            progress: 0.7,
          ),
          // Ride
          _buildActivityCard(
            icon: Icons.directions_car,
            title: "Ride to Office",
            subtitle: "Toyota Camry • 4 mins away",
            status: "Driver approaching",
            color: AppTheme.primaryRed,
            progress: 0.3,
          ),
          // Shop
          _buildActivityCard(
            icon: Icons.shopping_bag,
            title: "Grocery Order",
            subtitle: "Whole Foods • Preparing",
            status: "Packing items",
            color: Colors.blue,
            progress: 0.2,
          ),

          const SizedBox(height: 30),
          const Text("My Tasks",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildTaskItem("Call Mom", "Today, 8:00 PM", true),
          _buildTaskItem("Pay Electricity Bill", "Tomorrow", false),
          _buildTaskItem("Book Dentist Appointment", "Next Week", false),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required Color color,
    required double progress,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(8)),
                child: Text(status,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation(color),
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String subtitle, bool isDone) {
    return ListTile(
      leading: Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isDone ? Colors.green : Colors.grey),
      title: Text(title,
          style: TextStyle(
              color: Colors.white,
              decoration: isDone ? TextDecoration.lineThrough : null)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
    );
  }
}
