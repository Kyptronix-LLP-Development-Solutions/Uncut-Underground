import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uncut_underground/common/text_widget.dart';
// import 'package:uncut_underground/utils/theme/theme.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:uncut_underground/presentation/root/root_screen.dart';

import '../../../common/loading_indicator.dart';
import '../backend/loginwithgoogle.dart';
import 'admin_login.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Scaffold(
          body: SizedBox(
            height: double.infinity,
            child: Stack(
              children: [
                /* -------------------------------- Login text ------------------------------- */

                Container(
                  height: MediaQuery.sizeOf(context).height * 0.25,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.green.shade900,
                    Colors.green,
                  ])),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget01(
                        text: 'Log In',
                        fontSize: 28.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      // Text(
                      //   "Log In",
                      //   style: TextStyle(
                      //       fontStyle: FontStyle.italic,
                      //       color: isDark ? Colors.grey : Colors.grey[600]),
                      // ),
                      Gap(10.0),
                      CustomTextWidget02(
                        text: 'Welcome back! Please sign in to continue.',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                /* ---------------------------------- body ---------------------------------- */
                Positioned(
                  top: MediaQuery.sizeOf(context).height * 0.24,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.75,
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /* -------------------------------------------------------------------------- */
                          /*                            continue with google                            */
                          /* -------------------------------------------------------------------------- */
                          const Gap(30.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: SocialLoginButton(
                              borderRadius: 12.0,
                              buttonType: SocialLoginButtonType.google,
                              onPressed: () async {
                                navigatePageFunc() async {
                                  /* Shared Preferences */
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();

                                  setState(() {
                                    prefs.setBool('isAdmin', false);
                                  });

                                  Navigator.push(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RootScreen(),
                                    ),
                                  );
                                }

                                final GoogleSignInProvider signInProvider =
                                    GoogleSignInProvider();
                                bool result =
                                    await signInProvider.googleLogin(context);
                                if (result == true) {
                                  navigatePageFunc();
                                }
                              },
                            ),
                          ),
                          const Gap(30.0),

                          /* -------------------------------------------------------------------------- */
                          /*                           continue with facebook                           */
                          /* -------------------------------------------------------------------------- */

                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 12.0),
                          //   child: SocialLoginButton(
                          //     borderRadius: 12.0,
                          //     buttonType: SocialLoginButtonType.facebook,
                          //     onPressed: () async {
                          //       final SharedPreferences prefs =
                          //           await SharedPreferences.getInstance();

                          //       setState(() {
                          //         prefs.setBool('isAdmin', false);
                          //       });
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => const RootScreen(),
                          //         ),
                          //       );
                          //       // navigatePageFunc() {}

                          //       // final GoogleSignInProvider signInProvider =
                          //       //     GoogleSignInProvider();
                          //       // bool result =
                          //       //     await signInProvider.googleLogin(context);
                          //       // if (result == true) {
                          //       //   navigatePageFunc();
                          //       // }
                          //     },
                          //   ),
                          // ),

                          /* -------------------------------------------------------------------------- */
                          /*                               swtich to admin                              */
                          /* -------------------------------------------------------------------------- */
                          const Gap(20.0),
                          Center(
                            child: TextButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AdminLogin(),
                                  ),
                                );
                              },
                              child: const CustomTextWidget01(
                                text: 'Switch to Admin',
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Gap(20.0),
                        ],
                      ),
                    ),
                  ),
                ),

                /* ---------------------------- loading indicator --------------------------- */
                if (isLoading)
                  const Center(
                    child: LoadingIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                                 validators                                 */
  /* -------------------------------------------------------------------------- */
  String? Function(String?)? emailValidator = (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  };

  String? Function(String?)? passwordValidator = (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 8) {
      return '• Password must be at least 8 characters long';
    } else if (!RegExp(r'(?=.*?[A-Z])').hasMatch(value)) {
      return '• Password must include an uppercase letter';
    } else if (!RegExp(r'(?=.*?[a-z])').hasMatch(value)) {
      return '• Password must include a lowercase letter';
    } else if (!RegExp(r'(?=.*?[0-9])').hasMatch(value)) {
      return '• Password must include a number';
    } else if (!RegExp(r'(?=.*?[!@#\$&*~])').hasMatch(value)) {
      return '• Password must include a symbol (e.g., !@#\$&*~)';
    }
    return null;
  };
}
