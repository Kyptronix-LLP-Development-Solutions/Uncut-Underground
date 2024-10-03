import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uncut_underground/utils/theme/theme.dart';
import '../chat/chat_contacts/chat_contact.dart';
import '../chat/chat_screen/user_chat_screen.dart';
import 'components/root_body.dart';

class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  bool isAdmin = false;

  accountPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isAdmin = prefs.getBool('isAdmin') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    accountPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Uncomment if you want an AppBar
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
              isAdmin
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatContact(),
                      ),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserChatScreen(),
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
