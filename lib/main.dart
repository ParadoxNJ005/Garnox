import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sembreaker/pages/HomePage.dart';
import 'package:sembreaker/pages/splash_screen.dart';
import 'package:sembreaker/utils/contstants.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBLysTDQ5ZZYfGy5EB1hzr6UpMNss2U33Q",
        appId: '1:713083156511:android:61ad2890f9d3d219fb3d2a',
        messagingSenderId: "713083156511",
        projectId: "sembreaker-49515",
      ),
    );

    // Enable Firebase Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } catch (e) {
    // debugPrint("Error initializing Firebase: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(
          splashColor: Constants.SKYBLUE,
          fontFamily: 'Montserrat',
          primaryColor: Constants.DARK_SKYBLUE,
          primaryIconTheme: const IconThemeData(color: Colors.white),
          indicatorColor: Constants.WHITE,
          primaryTextTheme: const TextTheme(
            headlineMedium: TextStyle(color: Colors.white),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Constants.WHITE,
            labelStyle:
            TextStyle(fontWeight: FontWeight.w600, color: Constants.WHITE),
            unselectedLabelColor: Constants.SKYBLUE,
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Constants.SKYBLUE,
          ),
        ),
        title: 'SemBreaker',
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => const HomePage(),
        },
        home: SplashScreen(),
      ),
    );
  }
}
