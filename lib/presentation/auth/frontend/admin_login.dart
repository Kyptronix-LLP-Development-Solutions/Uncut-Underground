import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:uncut_underground/common/input_field.dart';
// import 'package:uncut_underground/utils/theme/theme.dart';

import '../../root/root_screen.dart';

class AdminLogin extends ConsumerStatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminLoginState();
}

class _AdminLoginState extends ConsumerState<AdminLogin> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Image.asset(
                  'assets/logo/logo_ii.png',
                ),
              ),
              const Gap(24.0),
              InpuTFormField01(
                controller: _username,
                text: 'Enter username',
                isPassword: false,
              ),
              InpuTFormField01(
                controller: _password,
                text: 'Enter password',
                isPassword: true,
              ),
              const Gap(24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SocialLoginButton(
                  buttonType: SocialLoginButtonType.generalLogin,
                  onPressed: () async {
                    if (_username.text.trim() == 'SuperAdmin' &&
                        _password.text.trim() == 'UncutUnderground') {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      setState(() {
                        prefs.setBool('isAdmin', true);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RootScreen(),
                        ),
                      );
                    }
                  },
                  borderRadius: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
