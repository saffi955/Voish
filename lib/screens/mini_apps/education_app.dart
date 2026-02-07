import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mini_app_scaffold.dart';

class EducationApp extends StatelessWidget {
  const EducationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MiniAppScaffold(
      title: "Voish Learning",
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Recommended for you",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withValues(alpha: 0.3),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                          ),
                          child: const Center(
                              child: Icon(Icons.play_circle_fill,
                                  size: 50, color: Colors.white54)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Course ${index + 1}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text("2h 30m • Beginner",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          const Text("Categories",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildCategoryChip("Coding"),
              _buildCategoryChip("Design"),
              _buildCategoryChip("Business"),
              _buildCategoryChip("Language"),
              _buildCategoryChip("Music"),
              _buildCategoryChip("Cooking"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Chip(
      backgroundColor: AppTheme.surfaceDark,
      label: Text(label, style: const TextStyle(color: Colors.white)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
