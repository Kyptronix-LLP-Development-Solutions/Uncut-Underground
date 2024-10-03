import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uncut_underground/utils/theme/theme.dart';

import '../chat_screen/chat_screen.dart';

// import 'chat_screen.dart';
class ChatContact extends StatefulWidget {
  const ChatContact({Key? key}) : super(key: key);

  @override
  State<ChatContact> createState() => _ChatContactState();
}

class _ChatContactState extends State<ChatContact> {
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
        body: const Center(child: Text('Select a contact to chat')),
      ),
    );
  }
}
