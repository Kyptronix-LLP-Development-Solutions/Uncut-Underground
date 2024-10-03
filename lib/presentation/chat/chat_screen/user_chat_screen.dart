import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserChatScreen extends StatefulWidget {
  // final String recipientId;
  // final String recipientName;

  const UserChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  // final String _currentUserId =
  //     "your_current_user_id"; // Set your current user ID
  String _currentUserId = ''; // Empty string to hold the current user ID
  String recipientId = 'SuperAdminIdUnique';
  String recipientName = 'Admin';

  // Create a unique room ID by combining current user ID and recipient ID
  String _getRoomId(String userId1, String userId2) {
    if (userId1.compareTo(userId2) > 0) {
      return '${userId1}_$userId2';
    } else {
      return '${userId2}_$userId1';
    }
  }

  // Send message to Firestore
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    String roomId = _getRoomId(_currentUserId, recipientId);

    FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .add({
      'senderId': _currentUserId,
      'recipientId': recipientId,
      'message': _messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Optionally, update the last message in the chat room document
    FirebaseFirestore.instance.collection('chat_rooms').doc(roomId).set({
      'participants': [_currentUserId, recipientId],
      'lastMessage': _messageController.text.trim(),
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    _messageController.clear();
  }

  @override
  void initState() {
    _getCurrentUser(); // Fetch the current user ID
    super.initState();
  }

  // Method to get the current user ID from FirebaseAuth
  void _getCurrentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String roomId = _getRoomId(_currentUserId, recipientId);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipientName),
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(roomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index]['message'];
                    var isMe = messages[index]['senderId'] == _currentUserId;
                    return ListTile(
                      title: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(message),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Message Input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
