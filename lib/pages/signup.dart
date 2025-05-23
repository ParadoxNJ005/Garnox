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

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isAnimate = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isAnimate = true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    final OutlineInputBorder textFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.black),
    );

    Future<UserCredential?> signInWithGoogle() async {
      try {
        await InternetAddress.lookup('google.com');
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
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


    handleGoogleBtnClick() {
      Dialogs.showProgressBar(context);

      signInWithGoogle().then((user) async {
        Navigator.pop(context);

        if (user != null) {
          final email = user.user?.email;
          if (email != null) {
            if ((await APIs.userExists())) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                    (Route<dynamic> route) => false,
              );
            } else {
              APIs.createGoogleUser().then((value) => {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const CollegeDetails()),
                      (Route<dynamic> route) => false,
                )
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

    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
    );

    bool validateCredentials(String name, String email, String password, String confirmPassword) {
      if (name.trim().isEmpty || name.length < 3) {
        Dialogs.showSnackbar(context, "Name must be at least 3 characters long.");
        return false;
      }

      if (!email.endsWith('@gmail.com') && !email.endsWith('@iiita.ac.in')) {
        Dialogs.showSnackbar(context, "Email must be a valid Gmail or IIITA email.");
        return false;
      }

      if (password.length <= 6) {
        Dialogs.showSnackbar(context, "Password must be more than 6 characters.");
        return false;
      }

      if (password != confirmPassword) {
        Dialogs.showSnackbar(context, "Passwords do not match.");
        return false;
      }
      return true;
    }

    void handleSubmit() async {
      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String confirmPassword = confirmPasswordController.text.trim();

      if (validateCredentials(name, email, password, confirmPassword)) {
        if((await APIs.checkEmailExistsInFirestore(email))){
          Dialogs.showSnackbar(context, "Email Already Exists");
          return;
        }

        if (password != confirmPassword) {
          Dialogs.showSnackbar(context, "Passwords do not match");
          return;
        }

        Dialogs.showProgressBar(context);
        final userCredential = await APIs.signupWithEmailAndPassword(name, email, password);
        Navigator.pop(context);

        if (userCredential != null) {
          Dialogs.showSnackbar(context, "Signup successful");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const CollegeDetails()),
                (Route<dynamic> route) => false,
          );
        } else {
          Dialogs.showSnackbar(context, "Signup failed.");
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            SizedBox(
              width: double.infinity,
              height: 200,
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
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.WHITE,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.black),
                        ),
                        elevation: 1,
                      ),
                      onPressed: () {
                        handleGoogleBtnClick();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',
                            height: mq.height * .035,
                          ),
                          const SizedBox(width: 26),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: 16),
                              children: [
                                TextSpan(text: 'Sign Up With Google'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  const Text("----------------------------------OR-----------------------------------"),
                  const SizedBox(height: 15,),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: textFieldBorder,
                      enabledBorder: textFieldBorder,
                      focusedBorder: focusedBorder,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16.0),
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
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 15.0),
                  // Password TextField
                // For Confirm Password field

                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: textFieldBorder,
                      enabledBorder: textFieldBorder,
                      focusedBorder: focusedBorder,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword; // Toggle password visibility
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 15.0),
      // Confirm Password TextField
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: textFieldBorder,
                      enabledBorder: textFieldBorder,
                      focusedBorder: focusedBorder,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword; // Toggle confirm password visibility
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 15.0),
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
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}