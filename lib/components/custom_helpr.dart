import 'package:flutter/material.dart';
import '../utils/contstants.dart';

class Dialogs{
  static void showSnackbar(BuildContext context , String t) {
    final snackBar = SnackBar(
      content: Center(
        child: Text(
          t,
          style: TextStyle(color: Constants.BLACK, fontSize: 15),
        ),
      ),
      backgroundColor: Constants.WHITE,
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
              strokeWidth: 1,
            )));
  }

}