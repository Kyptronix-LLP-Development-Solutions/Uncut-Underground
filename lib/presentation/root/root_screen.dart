import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'components/root_body.dart';

class RootScreen extends ConsumerWidget {
  const RootScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SafeArea(
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
        body: RootBody(),
        // body: LoginPage(),
      ),
    );
  }
}
