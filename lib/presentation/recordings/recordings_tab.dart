import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uncut_underground/utils/theme/theme.dart';

import '../../common/live_page.dart';
import '../../common/popup_widget.dart';
import '../../common/text_widget.dart';

class RecordingsTab extends ConsumerStatefulWidget {
  const RecordingsTab({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecordingsTabState();
}

class _RecordingsTabState extends ConsumerState<RecordingsTab> {
  DocumentSnapshot? lastDocument;
  bool isLoading = false;
  List<DocumentSnapshot>? loadedDocuments;

  Future<void> fetchMoreUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot querySnapshot;
      if (lastDocument != null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .startAfterDocument(lastDocument!)
            .limit(1) // Fetch 1 more user
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .limit(1) // Fetch the first user
            .get();
      }

      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;
        if (loadedDocuments != null) {
          loadedDocuments!.add(lastDocument!);
        } else {
          loadedDocuments = [lastDocument!];
        }
      } else {
        // Handle the case where no documents are fetched
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Uh Oh!',
            message: 'No more users found...',
            contentType: ContentType.help,
          ),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e) {
      // Handle error
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'On Snap!',
          message: 'Error $e has occurred',
          contentType: ContentType.failure,
        ),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _joinLive(String liveId, String username, String userid, bool isHost) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(
          liveID: liveId,
          isHost: isHost,
          userId: userid,
          userName: username,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    loadedDocuments = [];
    fetchMoreUsers();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20.0),
                /* ---------------------------------- name ---------------------------------- */
                const CustomTextWidget01(
                  text: 'Hi Admin,',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),

                const Gap(20.0),

                /* --------------------------- live stream button --------------------------- */
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.black,
                      backgroundColor: isDark ? Colors.black : kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      final liveId = generateRandomString(8);

                      CustomPopupBox.show(
                        context,
                        const CustomTextWidget01(
                          text: 'Share Live Stream ID',
                          fontWeight: FontWeight.w800,
                          fontSize: 24.0,
                          color: Colors.black54,
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          height: 50.0,
                          decoration:
                              BoxDecoration(color: Colors.amber.shade50),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomTextWidget02(
                                text: liveId,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                              const Icon(Icons.copy_outlined)
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {
                              _joinLive(
                                liveId,
                                'admin',
                                '_____',
                                true,
                              );
                            },
                            child: const CustomTextWidget01(
                              text: 'Create',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                    child: const CustomTextWidget02(
                      text: 'Create a live stream',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Gap(20.0),
                Divider(
                  thickness: 2.0,
                  color: isDark ? Colors.black : kPrimaryColor,
                ),
                const Gap(20.0),
                /* ------------------------------ members list ------------------------------ */
                const CustomTextWidget01(
                  text: 'Members List',
                  fontWeight: FontWeight.w500,
                ),
                const Divider(
                  thickness: 0.5,
                ),
                const Gap(20.0),
                //

                if (isLoading &&
                    (loadedDocuments == null || loadedDocuments!.isEmpty))
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: loadedDocuments!.length + 1,
                    itemBuilder: (_, i) {
                      if (i < loadedDocuments!.length) {
                        final data =
                            loadedDocuments![i].data() as Map<String, dynamic>?;
                        if (data != null) {
                          return Theme(
                            data: ThemeData(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: CustomTextWidget02(
                                text: data['name'] ?? 'Name not available',
                                fontSize: 14.0,
                              ),
                              children: [
                                CustomTextWidget02(
                                  text: data['email'] ?? 'Email not available',
                                  fontSize: 14.0,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const ListTile(
                            title: Text('Name not available'),
                            subtitle: Text('Email not available'),
                          );
                        }
                      } else {
                        if (lastDocument != null) {
                          return Center(
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.9,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isDark ? Colors.black : kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () {
                                  fetchMoreUsers();
                                },
                                child: const CustomTextWidget01(
                                  text: 'Load More',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(); // End of list indicator
                        }
                      }
                    },
                  ),

                //  */
                const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ------------------------- generate random String ------------------------- */

String generateRandomString(int length) {
  final random = Random();
  const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}
