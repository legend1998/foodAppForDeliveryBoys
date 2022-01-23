import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartdelivery/HomePageScreen.dart';
import 'package:smartdelivery/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          visualDensity: VisualDensity(vertical: 0.5, horizontal: 0.5),
          primarySwatch: MaterialColor(
            0xFFE91E63,
            <int, Color>{
              50: Color(0xFFFCE4EC),
              100: Color(0xFFF8BBD0),
              200: Color(0xFFF48FB1),
              300: Color(0xFFF06292),
              400: Color(0xFFEC407A),
              500: Color(0xFFE91E63),
              600: Color(0xFFD81B60),
              700: Color(0xFFC2185B),
              800: Color(0xFFAD1457),
              900: Color(0xFF880E4F),
            },
          ),
          primaryColor: Colors.pink[400],
          primaryColorBrightness: Brightness.light,
          primaryColorLight: Colors.pink,
          primaryColorDark: Colors.black,
          canvasColor: Colors.white,
          accentColor: Color(0xff457BE0),
          accentColorBrightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          bottomAppBarColor: Colors.pink[600],
          cardColor: Colors.white,
          dividerColor: Color(0x1f6D42CE),
          focusColor: Color(0x1aF5E0C3),
          appBarTheme: AppBarTheme(backgroundColor: Colors.white)),
      home: HomePageScreen(),
    );
  }
}
