import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/artist/artist_group_provider.dart';
import 'providers/artist/artist_provider.dart';
import 'providers/event/event_artist_provider.dart';
import 'providers/event/event_provider.dart';
import 'providers/event/event_live_provider.dart';
import 'providers/event/event_vod_provider.dart';
import 'providers/notice/notice_provider.dart';
import 'providers/ticket/user_pass_provider.dart';
import 'providers/ticket/vote_ticket_provider.dart';
import 'providers/user/user_provider.dart';
import 'providers/vote/vote_artist_provider.dart';
import 'providers/vote/vote_provider.dart';
import 'providers/vote/vote_reward_media_provider.dart';
import 'package:provider/provider.dart';
import 'providers/ticket/live_ticket_provider.dart';
import 'providers/ticket/vod_ticket_provider.dart';
import 'screens/user/login_screen.dart';
import 'screens/user/google_signup_screen.dart';
import 'screens/user/x_signup_screen.dart';
import 'screens/info/notice_screen.dart';
import 'screens/info/faq_screen.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/env/.env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArtistProvider()),
        ChangeNotifierProvider(create: (context) => ArtistGroupProvider(
          Provider.of<ArtistProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => EventArtistProvider()),
        ChangeNotifierProvider(create: (_) => EventVODProvider()),
        ChangeNotifierProvider(create: (_) => EventLiveProvider()),
        ChangeNotifierProvider(create: (_) => NoticeProvider()),
        ChangeNotifierProvider(create: (_) => VODTicketProvider()),
        ChangeNotifierProvider(create: (_) => VoteTicketProvider()),
        ChangeNotifierProvider(create: (_) => LiveTicketProvider()),
        ChangeNotifierProvider(create: (_) => UserPassProvider()),
        ChangeNotifierProvider(create: (_) => VoteArtistProvider()),
        ChangeNotifierProvider(create: (_) => VoteProvider()),
        ChangeNotifierProvider(create: (_) => VoteRewardMediaProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
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