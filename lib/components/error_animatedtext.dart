import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ErrorAnimatedText extends StatelessWidget {
  const ErrorAnimatedText({required Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TyperAnimatedTextKit(
            speed: Duration(milliseconds: 100),
            text: [
              "Oops😵, Something went wrong",
              "Try checking your Internet Connection😃"
            ],
            textStyle: TextStyle(
              fontSize: 25.0, // Adjust as needed
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
