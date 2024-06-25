import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uncut_underground/presentation/record/record_tab.dart';
import 'package:uncut_underground/presentation/record/record_tab_controller.dart';
import 'package:uncut_underground/presentation/recordings/recordings_tab.dart';

class TabBarViewWidget extends ConsumerWidget {
  const TabBarViewWidget({
    Key? key,
    required TabController tabController,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: Colors.white),
        child: TabBarView(
          controller: _tabController,
          physics: ref.watch(isTimerStoppedProvider)
              ? null
              : const NeverScrollableScrollPhysics(),
          children: const [
            RecordTab(),
            RecordingsTab(),
          ],
        ),
      ),
    );
  }
}
