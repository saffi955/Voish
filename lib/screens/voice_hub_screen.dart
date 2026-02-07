import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/app_theme.dart';
import '../widgets/voice_mic_button.dart';
import '../services/voice_service.dart';
import '../services/auth_service.dart';
import 'mini_apps/food_app.dart';
import 'mini_apps/ride_app.dart';
import 'mini_apps/shopping_app.dart';
import 'mini_apps/offers_app.dart';
import 'mini_apps/earn_app.dart';
import 'mini_apps/education_app.dart';
import 'mini_apps/chat_app.dart';
import 'mini_apps/doctor_app.dart';
import 'mini_apps/wallet_app.dart';
import 'mini_apps/placeholder_app.dart';

class VoiceHubScreen extends StatefulWidget {
  const VoiceHubScreen({super.key});

  @override
  State<VoiceHubScreen> createState() => _VoiceHubScreenState();
}

class _VoiceHubScreenState extends State<VoiceHubScreen> {
  final VoiceService _voiceService = VoiceService();
  bool _isListening = false;
  String _recognizedText = "Adjusting atmosphere...";

  @override
  void initState() {
    super.initState();
    _voiceService.init();
  }

  void _toggleListening() async {
    if (_isListening) {
      await _voiceService.stopListening();
      setState(() {
        _isListening = false;
        _recognizedText = "Processing...";
      });
      _processCommand(_voiceService.lastWords);
    } else {
      setState(() {
        _isListening = true;
        _recognizedText = "Listening...";
      });
      await _voiceService.startListening(onResult: (text) {
        setState(() {
          _recognizedText = text;
        });
      });
    }
  }

  void _processCommand(String command) {
    final cmd = command.toLowerCase();
    if (cmd.contains("food") || cmd.contains("order") || cmd.contains("eat")) {
      _navigateToService(context, 'Food');
    } else if (cmd.contains("ride") ||
        cmd.contains("cab") ||
        cmd.contains("go")) {
      _navigateToService(context, 'Ride');
    } else if (cmd.contains("shop") || cmd.contains("buy")) {
      _navigateToService(context, 'Shopping');
    } else if (cmd.contains("chat") || cmd.contains("message")) {
      _navigateToService(context, 'Chat');
    } else if (cmd.contains("wallet") || cmd.contains("balance")) {
      _navigateToService(context, 'Wallet');
    }
    // Reset after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _recognizedText = "Tap to speak";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final displayName = user?.displayName ?? "User";

    // Offers removed from grid, moved to special section
    final List<Map<String, dynamic>> services = [
      {'icon': FeatherIcons.messageCircle, 'label': 'Chat'},
      {'icon': Icons.fastfood, 'label': 'Food'},
      {'icon': FeatherIcons.shoppingBag, 'label': 'Shopping'},
      {'icon': Icons.directions_car, 'label': 'Ride'},
      {'icon': Icons.movie, 'label': 'Tickets'},
      {'icon': Icons.health_and_safety, 'label': 'Doctor'},
      {'icon': FeatherIcons.bookOpen, 'label': 'Education'},
      {'icon': Icons.attach_money, 'label': 'Earn'},
      {'icon': Icons.account_balance_wallet, 'label': 'Wallet'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Good Morning,",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16)),
                          Text(displayName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      // Catchy Offers Section
                      GestureDetector(
                        onTap: () => _navigateToService(context, 'Offers'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryRed.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    AppTheme.primaryRed.withValues(alpha: 0.5)),
                          ),
                          child: const Text("Feeling Lucky? 🍀",
                              style: TextStyle(
                                  color: AppTheme.primaryRed,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),

                // Minimalist Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                        20, 10, 20, 200), // Space for Mic
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 30, // More breathing room
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return _buildMinimalServiceItem(
                        icon: service['icon'],
                        label: service['label'],
                        onTap: () =>
                            _navigateToService(context, service['label']),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Inline Earth Mic
          Positioned(
            bottom: -90,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: VoiceMicButton(
                  onTap: _toggleListening,
                  isListening: _isListening,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _recognizedText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 18,
                      letterSpacing: 1.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalServiceItem(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToService(BuildContext context, String label) {
    Widget screen;
    switch (label) {
      case 'Food':
        screen = const FoodApp();
        break;
      case 'Ride':
        screen = const RideApp();
        break;
      case 'Shopping':
        screen = const ShoppingApp();
        break;
      case 'Offers':
        screen = const OffersApp();
        break;
      case 'Earn':
        screen = const EarnApp();
        break;
      case 'Education':
        screen = const EducationApp();
        break;
      case 'Chat':
        screen = const ChatApp();
        break;
      case 'Doctor':
        screen = const DoctorApp();
        break;
      case 'Wallet':
        screen = const WalletApp();
        break;
      default:
        screen = PlaceholderApp(title: "Voish $label");
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
