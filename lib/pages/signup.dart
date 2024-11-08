import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sembreaker/pages/signIn.dart';
import '../database/Apis.dart';
import 'CollegeDetails.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late Animation<Offset> animation1;
  late AnimationController _controller2;
  late Animation<Offset> animation2;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark, // Light or dark depending on background color
    ));

    // Animation 1
    _controller1 = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    animation1 = Tween<Offset>(
      begin: Offset(0.0, -5.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.bounceInOut),
    );

    // Animation 2
    _controller2 = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    animation2 = Tween<Offset>(
      begin: Offset(0.0, 5.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.elasticInOut),
    );

    _controller1.forward();
    _controller2.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100), // Add some space from the top
              SlideTransition(
                position: animation1,
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              SlideTransition(
                position: animation1,
                child: Text(
                  "Create an account to access meditations,",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                ),
              ),
              SlideTransition(
                position: animation1,
                child: Text(
                  "sleep sounds, music to help you focus, and",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                ),
              ),
              SlideTransition(
                position: animation1,
                child: Text(
                  "more",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(height: 30),
              SlideTransition(
                position: animation1,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => Signin()));
                  },
                  child: Text(
                    "Already have an account? Log in",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SlideTransition(
                position: animation2,
                child: TextFormField(
                  controller: firstNameController,
                  key: ValueKey('firstName'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "First Name",
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black), // label text color
                  ),
                  style: TextStyle(color: Colors.black), // input text color
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Invalid name";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(height: 15),
              SlideTransition(
                position: animation2,
                child: TextFormField(
                  controller: lastNameController,
                  key: ValueKey('lastName'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Last Name",
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black), // label text color
                  ),
                  style: TextStyle(color: Colors.black), // input text color
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Invalid name";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(height: 15),
              SlideTransition(
                position: animation2,
                child: TextFormField(
                  controller: emailController,
                  key: ValueKey('Email'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Email address*",
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black), // label text color
                  ),
                  style: TextStyle(color: Colors.black), // input text color
                  validator: (value) {
                    if (!(value.toString().contains("@"))) {
                      return 'Invalid Email';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(height: 15),
              SlideTransition(
                position: animation2,
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  key: ValueKey('Password'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Password (8+ characters)*",
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black), // label text color
                    suffixIcon:
                    Icon(Icons.emoji_events_outlined, color: Colors.black), // add your desired icon here
                  ),
                  style: TextStyle(color: Colors.black), // input text color
                  validator: (value) {
                    if (value.toString().length < 8) {
                      return 'Password is too short';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(height: 15),
              SlideTransition(
                position: animation2,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // Show progress indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue, // Set the color to blue
                              ),
                            );
                          },
                        );

                        try {
                          // Perform the signup operation
                          await APIs.signup(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            firstNameController.text.trim(),
                            lastNameController.text.trim(),
                          );

                          // Dismiss the progress indicator
                          Navigator.pop(context);

                          // Navigate to the home screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => CollegeDetails()),
                          );
                        } catch (error) {
                          // Dismiss the progress indicator
                          Navigator.pop(context);

                          // Show an error message (this can be customized)
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(error.toString()),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        // Show error dialog if form is not valid
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  'Please fix the errors in the form before submitting.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      "Create an Account",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFF407BFF)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SlideTransition(
                position: animation2,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF407BFF), width: 2.0),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Handle Google sign-in

                      APIs.googleSignIn().then((user) async {
                        Navigator.pop(context);



                        if (user != null) {
                          log('\nUser: ${user.user}');
                          log('\nUser Additional Info: ${user.additionalUserInfo}');

                          if (!mounted) return;

                          if ((await APIs.userExists())) {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (_) =>  CollegeDetails()));
                          } else {
                            APIs.createGoogleUser().then((value) => {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (_) =>  CollegeDetails()))
                            });
                          }
                        }
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 30),
                        Text(
                          "Continue with Google",
                          style: TextStyle(color: Color(0xFF407BFF)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Image.asset("assets/images/google_logo.png"),
                        )
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFFFFFFFF)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Add some space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
