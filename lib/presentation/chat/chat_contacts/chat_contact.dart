import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uncut_underground/utils/theme/theme.dart';

import '../chat_screen/chat_screen.dart';

class ChatContact extends StatefulWidget {
  const ChatContact({Key? key}) : super(key: key);

  @override
  State<ChatContact> createState() => _ChatContactState();
}

class _ChatContactState extends State<ChatContact> {
  final String _currentUserId =
      'SuperAdminIdUnique'; // Set directly to 'SuperAdminIdUnique'

  // Fetch chat rooms where the current user is a participant
  Stream<QuerySnapshot> _getChatRooms() {
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('participants', arrayContains: _currentUserId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contact Lists'),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () => _showUsersPopup(context),
          child: const Icon(
            Icons.person_add,
            color: Colors.white,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _getChatRooms(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var chatRooms = snapshot.data!.docs;
            if (chatRooms.isEmpty) {
              return const Center(child: Text('No chats available'));
            }
            return ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                var room = chatRooms[index];
                var participants = room['participants'] as List;
                var otherUserId =
                    participants.firstWhere((id) => id != _currentUserId);

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(otherUserId)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return const ListTile(
                        title: Text('Loading...'),
                      );
                    }

                    var userData = userSnapshot.data!;
                    var recipientName = userData['name'];

                    return ListTile(
                      title: Text(recipientName),
                      subtitle: Text(room['lastMessage'] ?? ''),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              recipientId: otherUserId,
                              recipientName: recipientName,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showUsersPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var users = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  return ListTile(
                    title: Text(user['name']),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the popup
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            recipientId: user.id,
                            recipientName: user['name'],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
