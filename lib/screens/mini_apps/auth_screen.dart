import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/chat_service.dart';
import '../../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController(text: "+92 ");
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();

  final ChatService _chatService = ChatService();

  String? _verificationId;
  bool _codeSent = false;
  bool _isLoading = false;
  bool _needsName = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhone() async {
    String phone = _phoneController.text.trim().replaceAll(' ', '');
    if (!phone.startsWith("+92") && !phone.startsWith("+1")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Only +92 and +1 country codes are supported.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    await _chatService.verifyPhoneNumber(
      phoneNumber: phone,
      onCodeSent: (verificationId, resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _isLoading = false;
        });
      },
      onVerificationFailed: (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Auth Failed: ${e.message}")),
        );
      },
      onVerificationCompleted: (credential) async {
        // Auto-retrieval or instant verification (Android)
        await _signInWithCredential(credential);
      },
      onCodeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _signInWithSMS() async {
    if (_verificationId == null) return;

    setState(() => _isLoading = true);

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _otpController.text.trim(),
    );

    await _signInWithCredential(credential);
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential =
          await _chatService.signInWithCredential(credential);
      setState(() => _isLoading = false);

      // If name is missing (new user), prompt for it
      if (userCredential.user?.displayName == null ||
          userCredential.user!.displayName!.isEmpty) {
        setState(() => _needsName = true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign In Error: $e")),
        );
      }
    }
  }

  Future<void> _saveName() async {
    if (_nameController.text.isNotEmpty) {
      await _chatService.updateProfile(name: _nameController.text.trim());
      setState(() => _needsName = false);
      // After this, the Auth Warpper in ChatApp should pick up the change
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_needsName) {
      return _buildNameInput();
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Voish Chat",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 40),
            if (!_codeSent) ...[
              TextField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number (+92... or +1...)",
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.phone, color: AppTheme.primaryRed),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryRed)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyPhone,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Continue"),
              ),
            ] else ...[
              const Text(
                "Enter the code sent to your phone",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _otpController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "SMS Code",
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.lock, color: AppTheme.primaryRed),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryRed)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _signInWithSMS,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify & Login"),
              ),
              TextButton(
                onPressed: () => setState(() => _codeSent = false),
                child: const Text("Change Phone Number"),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("What's your name?",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Display Name (e.g. Reakos)",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primaryRed)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveName,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text("Start Chatting"),
            ),
          ],
        ),
      ),
    );
  }
}
