import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/app_theme.dart';
import 'auth_screen.dart';

class VersionSelectionScreen extends StatelessWidget {
  const VersionSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Choose Your Experience",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Select the version that fits your device and needs.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Lite Version
              _buildVersionCard(
                context,
                title: "Voish Lite",
                subtitle:
                    "Fast & lightweight. Optimized for performance on all devices.",
                icon: FeatherIcons.zap,
                color: Colors.orange,
                isRecommended: false,
              ),

              const SizedBox(height: 20),

              // Full Version
              _buildVersionCard(
                context,
                title: "Voish Full",
                subtitle:
                    "The complete super-app experience. All features included.",
                icon: FeatherIcons.layers,
                color: AppTheme.primaryRed,
                isRecommended: true,
              ),

              const SizedBox(height: 20),

              // Premium Version
              _buildVersionCard(
                context,
                title: "Voish Premium",
                subtitle: "Ad-free experience with exclusive priority support.",
                icon: FeatherIcons.award,
                color: Colors.purple,
                isRecommended: false,
                isPremium: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isRecommended,
    bool isPremium = false,
  }) {
    return GestureDetector(
      onTap: () {
        // Evaluate selection and go to Auth
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const AuthScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: isRecommended
              ? Border.all(color: color, width: 2)
              : Border.all(color: Colors.white10),
          boxShadow: isRecommended
              ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 15)]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      if (isPremium) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(4)),
                          child: const Text("PRO",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        )
                      ]
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            if (isRecommended)
              const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
