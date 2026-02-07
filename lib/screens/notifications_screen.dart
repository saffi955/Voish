import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
              icon: const Icon(FeatherIcons.checkSquare), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (c, i) =>
            const Divider(height: 1, color: Colors.white10),
        itemBuilder: (context, index) {
          final isUnread = index < 3;
          return Container(
            color: isUnread
                ? AppTheme.primaryRed.withValues(alpha: 0.05)
                : Colors.transparent,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceDark,
                ),
                child: Icon(
                  index % 2 == 0 ? Icons.discount : Icons.info,
                  color: isUnread ? AppTheme.primaryRed : Colors.white54,
                  size: 20,
                ),
              ),
              title: Text(
                "Notification Title ${index + 1}",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal),
              ),
              subtitle: const Text(
                "This is a detail description of the notification event that happened.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("2h ago",
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  if (isUnread)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: AppTheme.primaryRed, shape: BoxShape.circle),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
