import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/app_theme.dart';
import 'voice_hub_screen.dart';
import 'activity_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const VoiceHubScreen(),
    const ActivityScreen(), // Active Tasks
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceDark,
          border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent, // Using container color
          elevation: 0,
          selectedItemColor: AppTheme.primaryRed,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.mic, size: 22),
              label: 'Voice',
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.activity, size: 22),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.bell, size: 22),
              label: 'Updates',
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.user, size: 22),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
