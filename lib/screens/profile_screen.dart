import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    if (user == null) return const SizedBox(); // Should not happen if guarded

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Error loading profile"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data?.data() as Map<String, dynamic>?;
              final String displayName =
                  data?['name'] ?? user.displayName ?? "User";
              final String email = data?['email'] ?? user.email ?? "No Email";
              final bool hasKeys = data?.containsKey('publicKey') ?? false;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.surfaceDark,
                      backgroundImage: user.photoURL != null
                          ? NetworkImage(user.photoURL!)
                          : null,
                      child: user.photoURL == null
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(displayName,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text(email, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),

                    // Verification Status Grid
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          _buildVerificationRow("Account Active", true),
                          const Divider(color: Colors.white10),
                          _buildVerificationRow(
                              "Email Verified", user.emailVerified),
                          const Divider(color: Colors.white10),
                          _buildVerificationRow("E2EE Encryption", hasKeys),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Personal Info
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Personal Details",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold))),
                    const SizedBox(height: 10),
                    _buildInfoTile(Icons.perm_identity, "User ID", user.uid),
                    _buildInfoTile(
                        Icons.phone, "Phone", data?['phone'] ?? "N/A"),

                    const SizedBox(height: 40),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white10,
                          foregroundColor: Colors.redAccent,
                        ),
                        onPressed: () async {
                          await AuthService().signOut();
                          if (context.mounted) {
                            Navigator.of(context, rootNavigator: true)
                                .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const AuthScreen()),
                              (route) => false,
                            );
                          }
                        },
                        child: const Text("Logout"),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget _buildVerificationRow(String label, bool isVerified) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Row(
            children: [
              Text(isVerified ? "Verified" : "Pending",
                  style: TextStyle(
                      color: isVerified ? Colors.green : Colors.orange,
                      fontSize: 12)),
              const SizedBox(width: 8),
              Icon(isVerified ? Icons.check_circle : Icons.error,
                  color: isVerified ? Colors.green : Colors.orange, size: 16),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(value,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }
}
