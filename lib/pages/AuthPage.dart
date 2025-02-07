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
  bool _obscureText = true;
  bool _obscureText1= true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //for auto triggering animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isAnimate = true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
    final OutlineInputBorder textFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.black),
    );

    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
    );

    bool validateCredentials(String email, String password) {
      if (!email.endsWith('@gmail.com') && !email.endsWith('@iiita.ac.in')) {
        Dialogs.showSnackbar(context, "Email must be a valid Gmail or IIITA email.");
        return false;
      }

      if (password.length <= 6) {
       Dialogs.showSnackbar(context, "Password must be more than 6 characters.");
        return false;
      }
      return true;
    }

    void handleSubmit() async {
      String email = emailController.text;
      String password = passwordController.text;

      if (validateCredentials(email, password)) {
        Dialogs.showProgressBar(context);
        final userCredential = await APIs.loginWithEmailAndPassword(email, password);
        Navigator.pop(context);
        if (userCredential != null) {
          Dialogs.showSnackbar(context, "Login successful");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const HomePage()));
        } else {
          Dialogs.showSnackbar(context, "Login failed. Please try again.");
        }
      } else {
        Dialogs.showSnackbar(context, "Invalid Email And Password");
      }
    }


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center, // Ensures spacing between elements
          children: [
            const SizedBox(height: 100),
            SizedBox(
              width: double.infinity,
              height: 250,
              child: Center(
                child: Lottie.asset('assets/animation/aa.json', fit: BoxFit.fill),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Email TextField
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: textFieldBorder,
                      enabledBorder: textFieldBorder,
                      focusedBorder: focusedBorder,
                    ),
                    style: TextStyle(color: Colors.black), // Set text color
                  ),
                  const SizedBox(height: 16.0),
                  // Password TextField
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: textFieldBorder,
                      enabledBorder: textFieldBorder,
                      focusedBorder: focusedBorder,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: handleSubmit,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text("----------------------------------OR-----------------------------------")
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.WHITE,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Border radius of 10
                    side: const BorderSide(color: Colors.black), // Black border
                  ),
                  elevation: 1,
                ),
                onPressed: () {
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
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Adds padding at the bottom
          ],
        ),
      ),
    );
  }
}
