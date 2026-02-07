import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../theme/app_theme.dart';
import '../../services/chat_service.dart';
import 'auth_screen.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure properly authenticated
    return StreamBuilder<User?>(
      stream: ChatService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              backgroundColor: AppTheme.backgroundBlack,
              body: Center(
                  child:
                      CircularProgressIndicator(color: AppTheme.primaryRed)));
        }
        if (snapshot.hasData) {
          return const ChatHomeScreen();
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundBlack,
        appBar: AppBar(
          backgroundColor: AppTheme.surfaceDark,
          title: const Text("Voish Chat",
              style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: AppTheme.primaryRed,
            labelColor: AppTheme.primaryRed,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "CHATS"),
              Tab(text: "CALLS"),
            ],
          ),
          actions: [
            IconButton(icon: const Icon(FeatherIcons.search), onPressed: () {}),
            PopupMenuButton(
                icon: const Icon(FeatherIcons.moreVertical),
                color: AppTheme.surfaceDark,
                onSelected: (value) {
                  if (value == 'logout') _chatService.signOut();
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text("Log Out",
                            style: TextStyle(color: Colors.white)),
                      )
                    ]),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.primaryRed,
          child: const Icon(Icons.message),
          onPressed: () {
            // Open Contact Select Screen
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SelectContactScreen()));
          },
        ),
        body: const TabBarView(
          children: [
            ChatsListTab(),
            CallsListTab(),
          ],
        ),
      ),
    );
  }
}

class ChatsListTab extends StatelessWidget {
  const ChatsListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatService chatService = ChatService();

    // In a real app, this should likely stream "my active chats" (chat_rooms where I am a member)
    // rather than "all users" which acts as a contact list.
    // However, for simplicity per user requirements of "WhatsApp style", usually the main screen is active conversations.
    // I'll stick to streaming 'users' for now as a "Contacts/Chats" hybrid to keep it running immediately
    // without complex "ChatRoom" list management logic yet (step 2 of E2EE will handle this better).
    // actually, let's try to do it right: Stream "users" is fine for a contact list, but this is the CHATS tab.
    // Let's assume for this prototype that the 'users' list IS the chat list (everyone is available).

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: chatService.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text("Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white)));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryRed));
        }

        final users = snapshot.data ?? [];

        if (users.isEmpty) {
          return const Center(
            child: Text("No contacts found. Invite friends!",
                style: TextStyle(color: Colors.grey)),
          );
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChatDetailScreen(
                            receiverId: user['uid'],
                            receiverName:
                                user['name'] ?? user['phone'] ?? 'Unknown')));
              },
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.surfaceDark,
                backgroundImage: user['photoURL'] != null
                    ? NetworkImage(user['photoURL'])
                    : null,
                child: user['photoURL'] == null
                    ? const Icon(Icons.person, color: Colors.white70)
                    : null,
              ),
              title: Text(
                user['name'] ?? user['phone'] ?? "User",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user['phone'] ?? '', // Could be last message in future
                style: const TextStyle(color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }
}

class CallsListTab extends StatelessWidget {
  const CallsListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.call, size: 48, color: Colors.grey),
        SizedBox(height: 16),
        Text("No recent calls", style: TextStyle(color: Colors.grey)),
      ],
    ));
  }
}

class SelectContactScreen extends StatefulWidget {
  const SelectContactScreen({super.key});

  @override
  State<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundBlack,
        appBar: AppBar(
          backgroundColor: AppTheme.surfaceDark,
          title: const Text("Select Contact"),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.primaryRed,
          child: const Icon(Icons.person_add),
          tooltip: "Add by Number",
          onPressed: () => _startChatByPhone(context),
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _chatService.getUsers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final users = snapshot.data!;
              if (users.isEmpty) {
                return const Center(
                  child: Text("No contacts found. Use + to add by phone.",
                      style: TextStyle(color: Colors.grey)),
                );
              }
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundColor: AppTheme.surfaceDark,
                          backgroundImage: user['photoURL'] != null
                              ? NetworkImage(user['photoURL'])
                              : null,
                          child: user['photoURL'] == null
                              ? const Icon(Icons.person, color: Colors.white)
                              : null),
                      title: Text(user['name'] ?? "Unknown",
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(user['phone'] ?? "",
                          style: const TextStyle(color: Colors.grey)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ChatDetailScreen(
                                    receiverId: user['uid'],
                                    receiverName: user['name'] ?? "Unknown")));
                      },
                    );
                  });
            }));
  }

  Future<void> _startChatByPhone(BuildContext context) async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          title: const Text(
            "Start chat by Phone",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: "Phone (e.g. +1...)",
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryRed)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(controller.text.trim());
              },
              child: const Text("Find",
                  style: TextStyle(color: AppTheme.primaryRed)),
            ),
          ],
        );
      },
    );

    if (result == null || result.isEmpty) return;

    final phone = result.replaceAll(' ', '');
    final data = await _chatService.findUserByPhone(phone);

    if (!mounted) return;

    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No user found with that phone. They must sign up first.",
          ),
        ),
      );
      return;
    }

    final receiverId = data['uid'] as String?;
    final receiverName =
        (data['name'] as String?) ?? (data['phone'] as String? ?? 'Unknown');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          receiverId: receiverId!,
          receiverName: receiverName,
        ),
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatDetailScreen(
      {super.key, required this.receiverId, required this.receiverName});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // In the next step, we will inject the Encryption Logic here
      await _chatService.sendMessage(
          widget.receiverId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceDark,
        leadingWidth: 70,
        leading: Row(
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)),
            const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 20, color: Colors.white)),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.receiverName, style: const TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(FeatherIcons.video), onPressed: () {}),
          IconButton(icon: const Icon(FeatherIcons.phone), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getMessages(
                  FirebaseAuth.instance.currentUser!.uid, widget.receiverId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primaryRed));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final isMe = data['senderId'] ==
                        FirebaseAuth.instance.currentUser!.uid;

                    // Decryption Logic
                    // We need senderId and receiverId (me) to derive the same key.
                    // receiverId in message doc is "me" (if incoming) or "them" (if outgoing).
                    // _deriveChatSessionKey sorts them, so order doesn't matter.
                    // We pass message['senderId'] and message['receiverId'].
                    // Safely handle legacy messages that might not have these fields.

                    String displayMessage = "";
                    if (data['encrypted'] == true) {
                      displayMessage = _chatService.decryptMessage(
                          data['message'],
                          data['senderId'] ?? '',
                          data['receiverId'] ?? '');
                    } else {
                      displayMessage =
                          data['message']; // Backward compatibility
                    }

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppTheme.primaryRed.withValues(alpha: 0.8)
                              : AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayMessage,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: AppTheme.surfaceDark,
      child: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.add, color: AppTheme.primaryRed),
              onPressed: () {}),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundBlack,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Message",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppTheme.primaryRed,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
