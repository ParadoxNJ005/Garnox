import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/contstants.dart';
import 'HomePage.dart';
import 'landingPage.dart';
import '../database/notif_api.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _connectivityTimer;
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constants.APPCOLOUR,
    ));

    _setupFirebaseNotifications();
    _checkInternetAndNavigate();
  }

  /// 🔥 **Request Notification Permission & Initialize Firebase Messaging**
  Future<void> _setupFirebaseNotifications() async {
    bool permissionGranted = await _requestNotificationPermission();
    if (permissionGranted) {
      FirebaseMessaging.instance.subscribeToTopic('all').then((_) {
        // debugPrint("Subscribed to 'all' topic");
      }).catchError((error) {
        // debugPrint("Error subscribing to topic: $error");
      });

      await FirebaseApi().initNotifications();
    }
  }

  /// 🚀 **Requests Notification Permission**
  Future<bool> _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  /// 🌐 **Checks Internet before Navigating**
  void _checkInternetAndNavigate() async {
    bool hasInternet = await _hasInternetConnection();

    if (!hasInternet) {
      _showNoInternetDialog();

      _connectivityTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        bool internetAvailable = await _hasInternetConnection();
        if (internetAvailable) {
          if (_isDialogShown && mounted) {
            Navigator.of(context, rootNavigator: true).pop();
            _isDialogShown = false;
          }
          _connectivityTimer?.cancel();
          _navigateToNextScreen();
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 2), _navigateToNextScreen);
    }
  }

  /// ✅ **Checks Internet Connection**
  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// 🏡 **Navigate to Home or Landing Page**
  Future<void> _navigateToNextScreen() async {
    const storage = FlutterSecureStorage();
    final temp = await storage.read(key: "me");

    if (mounted) {
      if (temp != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Landingpage()));
      }
    }
  }

  void _showNoInternetDialog() {
    if (!_isDialogShown && mounted) {
      _isDialogShown = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text(
                'No Internet Connection',
                style: TextStyle(color: Constants.DARK_SKYBLUE),
              ),
              content: const Text('Please enable your internet connection to continue.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    _isDialogShown = false;
                    Navigator.of(context, rootNavigator: true).pop();
                    _checkInternetAndNavigate();
                  },
                  child: const Text('Retry', style: TextStyle(color: Constants.SKYBLUE)),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _connectivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.APPCOLOUR,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svgIcons/applogo.svg', height: 100, width: 100),
            SizedBox(height: 20),
            Text(
              'SEMBREAKER',
              style: GoogleFonts.epilogue(
                textStyle: const TextStyle(fontSize: 40, color: Constants.WHITE, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
