import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:sembreaker/utils/contstants.dart';
import '../components/custom_helpr.dart';
import '../database/Apis.dart';
import 'CollegeDetails.dart';
import 'HomePage.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();

    //for auto triggering animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isAnimate = true);
    });
  }

  _handleGoogleBtnClick() {
    //for showing progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) async {
      Navigator.pop(context);

      if (user != null) {

        final email = user.user?.email;
        if (email != null) {
          if ((await APIs.userExists())) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          } else {
            APIs.createGoogleUser().then((value) => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const CollegeDetails()))
            });
          }
        } else {
          Dialogs.showSnackbar(context, "⚠️ Login Via Valid College Id!!");
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      Dialogs.showSnackbar(context, "Something Went Wrong(Check Internet!!)");
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures spacing between elements
        children: [
          const SizedBox(height: 50),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            width: double.infinity,
            height: 500,
            child: Center(
              child: Column(
                children: [
                  Lottie.asset('assets/animation/aa.json', fit: BoxFit.cover),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.SKYBLUE,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Border radius of 10
                ),
                elevation: 1,
              ),
              onPressed: (){
                _handleGoogleBtnClick();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/google_logo.png',
                    height: mq.height * .035,
                  ),
                  const SizedBox(width: 26), // Space between icon and text
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(text: 'Login with '),
                        TextSpan(
                          text: 'Google',
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),//ads padding at the bottom
        ],
      ),
    );
  }
}
