import 'package:flutter/material.dart';
import './ui/login.dart';
import './ui/register.dart';
import './ui/home.dart';
import './ui/profile.dart';
import './ui/friend.dart';

void main() => runApp(MyApp());
const MaterialColor myColor = const MaterialColor(
  0xfff06292,
  const <int, Color>{
    50: const Color(0xfff06292),
    100: const Color(0xfff06292),
    200: const Color(0xfff06292),
    300: const Color(0xfff06292),
    400: const Color(0xfff06292),
    500: const Color(0xfff06292),
    600: const Color(0xfff06292),
    700: const Color(0xfff06292),
    800: const Color(0xfff06292),
    900: const Color(0xfff06292),
  },
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Final',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: myColor,
        // appBarTheme: AppBarTheme(color: Color(0xfff06292))
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/friend': (context) => FriendScreen(),
      },
    );
  }
}