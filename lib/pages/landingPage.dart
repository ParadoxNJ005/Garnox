import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../utils/landing_info.dart';
import 'AuthPage.dart';

class Landingpage extends StatefulWidget {
  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  int currentIndex = 0;
  late PageController _controller;
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness:
          Brightness.dark, // Light or dark depending on background color
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 285),
          //   child: TextButton(
          //     onPressed: () {
          //       Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) => Auth(),
          //         ),
          //       );
          //     },
          //     child: Text(
          //       "Skip",
          //       style: TextStyle(
          //         fontSize: 19,
          //         color: Color(0xFF407BFF),
          //         fontWeight: FontWeight.bold,
          //         fontFamily: "MontSerrat",
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: landingContent.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          landingContent[i].image,
                          height: 200.0,
                        ),
                      ),
                      SizedBox(height: 50),
                      Center(
                        child: Text(
                          landingContent[i].desc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.0,
                            letterSpacing: 0.5,
                            color: Color(0xFFA3A9B7),
                            fontWeight: FontWeight.w500,
                            fontFamily: "MontSerrat",
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                landingContent.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          Container(
            height: 56,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: currentIndex == landingContent.length - 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF407BFF),
                              fontWeight: FontWeight.bold,
                              fontFamily: "MontSerrat",
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Auth(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            side: BorderSide(
                              // Blue border
                              color: Color(0xFF407BFF),
                              width: 1.0, // Border width
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            elevation: 3,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                              fontFamily: "MontSerrat",
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Auth(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF407BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            elevation: 3,
                          ),
                        ),
                      ),
                    ],
                  )
                : ElevatedButton(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                        fontFamily: "MontSerrat",
                      ),
                    ),
                    onPressed: () {
                      _controller.nextPage(
                        duration: Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF407BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10),
                      elevation: 3,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 20 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF407BFF),
      ),
    );
  }
}
