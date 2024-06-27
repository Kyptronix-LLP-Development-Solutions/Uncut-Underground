import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/custom_snackbar.dart';

class GoogleSignInProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> googleLogin(BuildContext context) async {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    final prefs = await SharedPreferences.getInstance();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Access user details
      final User? user = userCredential.user;

      if (user != null) {
        // Add user details to Firestore collection
        // await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        //   'userId': user.uid,
        //   'name': user.displayName,
        //   'email': user.email,
        //   'isSubscribed': false,
        //   // Add more fields as needed
        // });
        createUserIfNotExists(user);
        customSnackBar(
          scaffoldMessenger,
          'Google login successful.',
          Colors.green.shade800,
          Colors.white,
        );

        await prefs.setBool('admin', true);

        return true; // Return true if login is successful
      }
    } catch (e) {
      customSnackBar(
        scaffoldMessenger,
        'Google login failed. $e',
        Colors.red,
        Colors.white,
      );
    }
    return false; // Return false if there's an error
  }

  Future<void> logout() async {
    // Sign out from Firebase Authentication
    await _auth.signOut();
    //
    if (_googleSignIn.currentUser != null) {
      // Disconnect the user from Google sign-in
      await _googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
    }
  }
}

Future<void> createUserIfNotExists(User user) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

  return FirebaseFirestore.instance.runTransaction((transaction) async {
    final snapshot = await transaction.get(userRef);

    if (!snapshot.exists) {
      // Document doesn't exist, so create it
      transaction.set(userRef, {
        'userId': user.uid,
        'name': user.displayName,
        'email': user.email,
        'isSubscribed': false,
        // Add more fields as needed
      });
    } else {
      // Document already exists, you can optionally update certain fields here
      // For example:
      // transaction.update(userRef, {'lastLoginDate': DateTime.now()});
    }
  });
}
