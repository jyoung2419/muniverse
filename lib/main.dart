import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:muniverse_app/providers/event/detail/event_info_provider.dart';
import 'package:muniverse_app/providers/event/main/event_main_provider.dart';
import 'package:muniverse_app/providers/event/detail/event_vote_provider.dart';
import 'package:muniverse_app/providers/event/main/event_main_related_provider.dart';
import 'package:muniverse_app/providers/vote/main_vote_provider.dart';
import 'package:muniverse_app/providers/vote/vote_detail_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/artist/artist_group_provider.dart';
import 'providers/artist/artist_provider.dart';
import 'providers/event/detail/event_provider.dart';
import 'providers/event/detail/event_live_provider.dart';
import 'providers/event/detail/event_vod_provider.dart';
import 'providers/notice/notice_provider.dart';
import 'providers/ticket/user_pass_provider.dart';
import 'providers/ticket/vote_ticket_provider.dart';
import 'providers/user/google_oauth_provider.dart';
import 'providers/user/user_provider.dart';
import 'providers/vote/vote_artist_provider.dart';
import 'providers/vote/vote_provider.dart';
import 'providers/vote/vote_reward_media_provider.dart';
import 'package:provider/provider.dart';
import 'providers/ticket/live_ticket_provider.dart';
import 'providers/ticket/vod_ticket_provider.dart';
import 'screens/user/login_screen.dart';
import 'screens/user/google_signup_screen.dart';
import 'screens/user/twitter_signup_screen.dart';
import 'screens/info/notice_screen.dart';
import 'screens/info/faq_screen.dart';
import 'screens/home/home_screen.dart';
import 'utils/dio_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/env/.env");
  await DioClient().init();
  await DioClient().loadCookies();

  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArtistProvider()),
        ChangeNotifierProvider(create: (context) => ArtistGroupProvider(
          Provider.of<ArtistProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => EventMainProvider()),
        ChangeNotifierProvider(create: (_) => EventInfoProvider()),
        ChangeNotifierProvider(create: (_) => EventVODProvider()),
        ChangeNotifierProvider(create: (_) => EventLiveProvider()),
        ChangeNotifierProvider(create: (_) => EventVoteProvider()),
        ChangeNotifierProvider(create: (_) => EventMainRelatedProvider()),
        ChangeNotifierProvider(create: (_) => NoticeProvider()),
        ChangeNotifierProvider(create: (_) => VODTicketProvider()),
        ChangeNotifierProvider(create: (_) => VoteTicketProvider()),
        // ChangeNotifierProvider(create: (_) => LiveTicketProvider()),
        ChangeNotifierProvider(create: (_) => UserPassProvider()),
        ChangeNotifierProvider(create: (_) => VoteArtistProvider()),  // 수정할거임..
        ChangeNotifierProvider(create: (_) => VoteProvider()),  // 이것도ㅠㅠ....
        ChangeNotifierProvider(create: (_) => VoteDetailProvider()),
        ChangeNotifierProvider(create: (_) => MainVoteProvider()),
        ChangeNotifierProvider(create: (_) => VoteRewardMediaProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GoogleOauthProvider()),
      ],
      child: MyApp(initialRoute: userId != null ? '/home' : '/login'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'muniverse',
      theme: ThemeData(fontFamily: "Pretendard"),
      initialRoute: initialRoute,

      routes: {
        '/login': (context) => const LoginScreen(),
        '/twitter_signup': (context) => const TwitterSignUpScreen(),
        '/notice': (context) => const NoticeScreen(),
        '/faq': (context) => const FAQScreen(),
        '/home': (context) => const HomeScreen(),
        // '/voteMainScreen': (context) => const VoteMainScreen(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/google_signup') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => GoogleSignUpScreen(
              email: args['email'] ?? '',
              name: args['name'] ?? '',
            ),
          );
        }
        return null;
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