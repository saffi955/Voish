import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        return await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null; // User canceled

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      debugPrint("Google Sign In Error: $e");
      return null;
    }
  }

  // Sign in with Email and Password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint("Email Sign In Error: $e");
      rethrow;
    }
  }

  // Sign Up with Email and Password
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Generate and store initial keys for E2EE
      if (cred.user != null) {
        await _generateAndStoreKeys(cred.user!);
      }

      return cred;
    } catch (e) {
      debugPrint("Email Sign Up Error: $e");
      rethrow;
    }
  }

  // Generate simple Identity Keys (Simulated for Prototype using Random Strings/AES Keys)
  // In a real Signal implementation, this would involve PreKeys, Signed PreKeys, etc.
  Future<void> _generateAndStoreKeys(User user) async {
    // We will use a simple "Identity Key" which is just a random string for now
    // In the ChatService, we will use this to 'derive' or 'verify' sessions.
    // Real implementation requires independent package or massive crypto boilerplate.

    // For this prototype:
    // publicKey = visible to others (stored in 'users/{uid}')
    // privateKey = stored locally only (simulated here since we don't have secure storage set up yet)

    // NOTE: In a real app, use flutter_secure_storage for the private key.
    // Here we will just store the public key in Firestore for looking up.

    final String publicKey =
        List.generate(32, (i) => i.toString()).join(); // Mock Key

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'publicKey': publicKey,
      'createdAt': FieldValue.serverTimestamp(),
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
