import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/user/login_screen.dart';
import 'screens/user/google_signup_screen.dart';
import 'screens/user/x_signup_screen.dart';
import 'screens/info/notice_screen.dart';
import 'screens/info/faq_screen.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/env/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'muniverse',
      theme: ThemeData(fontFamily: "NotoSansKR"),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/google_signup': (context) => const GoogleSignUpScreen(),
        '/x_signup': (context) => const XSignUpScreen(),
        '/notice': (context) => const NoticeScreen(),
        '/faq': (context) => const FAQScreen(),
        '/home': (context) => const HomeScreen(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
    );
  }
}