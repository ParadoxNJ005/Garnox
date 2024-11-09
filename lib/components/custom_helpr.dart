import 'package:flutter/material.dart';
import '../utils/contstants.dart';

class Dialogs{
  static void showSnackbar(BuildContext context , String t) {
    final snackBar = SnackBar(
      content: Center(
        child: Text(
          t,
          style: TextStyle(color: Constants.WHITE, fontSize: 15),
        ),
      ),
      backgroundColor: Constants.APPCOLOUR,
      duration: Duration(seconds: 1),
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