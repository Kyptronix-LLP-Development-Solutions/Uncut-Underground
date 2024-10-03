import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uncut_underground/utils/theme/theme.dart';
import '../chat/chat_contacts/chat_contact.dart';
import 'components/root_body.dart';

class RootScreen extends ConsumerWidget {
  const RootScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   titleSpacing: 0.0,
        //   leading: const Icon(
        //     Icons.video_chat_rounded,
        //     size: 30,
        //   ),
        //   title: Text(
        //     "Screen Recorder",
        //     style: FontStyles.montserratBold25(),
        //   ),
        //   actions: [ThemeToggle(ref: ref)],
        // ),
        body: const RootBody(),
        floatingActionButton: CircleAvatar(
          backgroundColor: kPrimaryColor,
          radius: 30.0,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatContact(),
                ),
              );
            },
            icon: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          ),
        ),
        // body: LoginPage(),
      ),
    );
  }
}
