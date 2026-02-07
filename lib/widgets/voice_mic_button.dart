import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/app_theme.dart';

class VoiceMicButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isListening;

  const VoiceMicButton({
    super.key,
    required this.onTap,
    this.isListening = false,
  });

  @override
  State<VoiceMicButton> createState() => _VoiceMicButtonState();
}

class _VoiceMicButtonState extends State<VoiceMicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 120, // Huge size
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryRed,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryRed.withValues(alpha: 0.5),
                  blurRadius: 20 * _scaleAnimation.value,
                  spreadRadius: 5 * _scaleAnimation.value,
                ),
              ],
            ),
            child: Icon(
              widget.isListening ? FeatherIcons.micOff : FeatherIcons.mic,
              color: Colors.white,
              size: 50,
            ),
          );
        },
      ),
    );
  }
}
