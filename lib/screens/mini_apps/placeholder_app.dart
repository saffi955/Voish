import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mini_app_scaffold.dart';

class PlaceholderApp extends StatelessWidget {
  final String title;
  const PlaceholderApp({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return MiniAppScaffold(
      title: title,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 60, color: AppTheme.textGrey),
            const SizedBox(height: 20),
            Text(
              "$title is coming soon!",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
