import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gotour_mobile/screens/auth.dart';
import 'package:gotour_mobile/widgets/main_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<String> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.containsKey('access_token'));
    if (kDebugMode) {
      prefs.remove('access_token');
    }
    bool loggedIn = prefs.containsKey('access_token');

    if (loggedIn == true) {
      return 'loggedIn';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoTour',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        primarySwatch: Colors.teal,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            minimumSize: const Size(double.infinity, 0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: FutureBuilder(
        future: isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return const AuthScreen();
          }
          return const MainMenu();
        },
      ),
    );
  }
}
