import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uncut_underground/common/text_widget.dart';
import 'package:uncut_underground/presentation/auth/frontend/login_page.dart';
import 'package:uncut_underground/presentation/root/components/tab_bar_view_widget.dart';
import 'package:uncut_underground/presentation/stripe_payments/backend/stripe_payment_function.dart';
import 'package:uncut_underground/utils/theme/theme.dart';

import '../../../common/live_page.dart';
import '../../../common/popup_widget.dart';
import 'tab_bar_widget.dart';

class RootBody extends ConsumerStatefulWidget {
  const RootBody({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RootBodyState();
}

class _RootBodyState extends ConsumerState<RootBody>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _streamId = TextEditingController();

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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
    return SafeArea(
      top: false,
      child: Container(
        color: isDark ? kDarkTextFieldBgColor : kPrimaryColor,
        child: Column(
          children: [
            const SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 13,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/logo/logo_white_ii.png',
                      height: 40.0,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: ThemeToggle(ref: ref),
                    ),
                    IconButton(
                      onPressed: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('counter');
                        _signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.logout_rounded,
                        color: isDark ? Colors.white : Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
            isAdmin
                ? TabBarWidget(tabController: _tabController)
                : const SizedBox(),
            isAdmin ? const SizedBox(height: 20) : const SizedBox(),
            isAdmin
                ? TabBarViewWidget(tabController: _tabController)
                : const SizedBox(),
            isAdmin
                ? const SizedBox()
                : Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          const Gap(50.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                // final liveId = generateRandomString(8);
                                CustomPopupBox.show(
                                  context,
                                  CustomTextWidget01(
                                    text: 'Enter Live ID',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 24.0,
                                    color:
                                        isDark ? Colors.white : Colors.black54,
                                  ),
                                  TextField(
                                    controller: _streamId,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[300],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100.0,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade800,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        _joinLive(
                                          _streamId.text.trim(),
                                          // userFetchData!.name,
                                          // userFetchData!.userId,
                                          'John Doe',
                                          'JohnDoe',
                                          false,
                                        );
                                      },
                                      child: const CustomTextWidget01(
                                        text: 'Join',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: const CustomTextWidget01(
                                text: 'Join a live stream',
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          /* -------------------------------------------------------------------------- */
                          /*                                     ---                                    */
                          /* -------------------------------------------------------------------------- */
                          // subscription button
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: ElevatedButton(
                              onPressed: () {
                                StripePaymentFunction().makePayment('99');
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.black),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Pay Now',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const Gap(20.0),
                          // const Divider(thickness: 3.0),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
