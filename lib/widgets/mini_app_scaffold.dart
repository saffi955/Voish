import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../theme/app_theme.dart';

class MiniAppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const MiniAppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.moreVertical),
            onPressed: () {},
          ),
        ],
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
