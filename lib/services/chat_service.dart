import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Authentication ---

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String, int?) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(PhoneAuthCredential)
        onVerificationCompleted, // Auto-resolve (Android only sometimes)
    required Function(String) onCodeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithCredential(
      PhoneAuthCredential credential) async {
    final userCredential = await _auth.signInWithCredential(credential);
    // Create/Update user doc on sign in
    if (userCredential.user != null) {
      await _updateUserLastSeen(userCredential.user!);
    }
    return userCredential;
  }

  Future<void> updateProfile({required String name}) async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Update Firebase Auth Profile
      await user.updateDisplayName(name);

      // Update Firestore Document
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'phone': user.phoneNumber,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> _updateUserLastSeen(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'phone': user.phoneNumber,
      'lastSeen': FieldValue.serverTimestamp(),
      // Don't overwrite 'name' if it exists, but create doc if it doesn't
    }, SetOptions(merge: true));
  }

  // --- Chat ---

  // --- Chat & Encryption ---

  // Mock "Shared Secret" derivation for prototype (Simulating ECDH)
  // In real app, this comes from X3DH Key Exchange using the User's Keys

  // Deterministic Key Derivation for two users (Symmetric)
  // This ensures both users generate the SAME AES key for their chat room.
  encrypt.Key _deriveChatSessionKey(String uid1, String uid2) {
    // Sort UIDs ensuring valid consistency
    List<String> uids = [uid1, uid2]..sort();
    String combined =
        "${uids[0]}_${uids[1]}_VOISH_SECRET_SALT"; // Mock Salt using server constant

    // Hash it to get 32 bytes for AES-256
    var bytes = utf8.encode(combined);
    var digest = sha256.convert(bytes);
    return encrypt.Key(digest.bytes as Uint8List);
  }

  // Encrypt
  String _encryptMessage(String plainText, String senderId, String receiverId) {
    final key = _deriveChatSessionKey(senderId, receiverId);
    final iv = encrypt.IV.fromLength(16); // Random IV
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    // Return format: "iv_base64:ciphertext_base64" to allow decryption
    return "${iv.base64}:${encrypted.base64}";
  }

  // Decrypt
  String decryptMessage(String blob, String senderId, String receiverId) {
    try {
      if (!blob.contains(":")) return blob; // Legacy/Plain fallback

      final parts = blob.split(":");
      final iv = encrypt.IV.fromBase64(parts[0]);
      final cipherText = encrypt.Encrypted.fromBase64(parts[1]);

      final key = _deriveChatSessionKey(senderId, receiverId);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      return encrypter.decrypt(cipherText, iv: iv);
    } catch (e) {
      return "⚠️ Decryption Failed";
    }
  }

  Stream<List<Map<String, dynamic>>> getUsers() {
    return _firestore
        .collection('users')
        .orderBy('lastSeen', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            // Filter out current user from the list locally for cleaner UI
            if (_auth.currentUser != null &&
                data['uid'] == _auth.currentUser!.uid) {
              return <String, dynamic>{};
            }
            return data;
          })
          .where((element) => element.isNotEmpty)
          .toList();
    });
  }

  Future<Map<String, dynamic>?> findUserByPhone(String phone) async {
    final query = await _firestore
        .collection('users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return query.docs.first.data();
  }

  // Generate a chat room ID for two users (e.g., "uid1_uid2" where uid1 < uid2)
  String getChatRoomId(String userId1, String userId2) {
    if (userId1.compareTo(userId2) < 0) {
      return '${userId1}_$userId2';
    } else {
      return '${userId2}_$userId1';
    }
  }

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String? currentUserName = _auth.currentUser!.displayName;
    final Timestamp timestamp = Timestamp.now();

    // ENCRYPT PAYLOAD
    final String encryptedContent =
        _encryptMessage(message, currentUserId, receiverId);

    Map<String, dynamic> newMessage = {
      'senderId': currentUserId,
      'senderName': currentUserName ?? 'Unknown',
      'receiverId': receiverId,
      'message': encryptedContent, // Storing CIPHERTEXT
      'timestamp': timestamp,
      'read': false,
      'encrypted': true, // Flag for UI
    };

    String chatRoomId = getChatRoomId(currentUserId, receiverId);

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage);

    // Update last message in the chat room doc for list views (optional optimization)
    await _firestore.collection('chat_rooms').doc(chatRoomId).set({
      'lastMessage':
          "User sent a secure message", // Don't leak content in summary
      'lastMessageTime': timestamp,
      'users': [currentUserId, receiverId],
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    String chatRoomId = getChatRoomId(userId, otherUserId);
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
