import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:muniverse_app/providers/translation_provider.dart';
import 'providers/product/product_kr_provider.dart';
import 'providers/product/product_usd_provider.dart';
import 'providers/vote/vote_availability_provider.dart';
import 'providers/event/detail/event_info_provider.dart';
import 'providers/event/detail/event_related_provider.dart';
import 'providers/event/main/event_main_provider.dart';
import 'providers/event/detail/event_vote_provider.dart';
import 'providers/event/main/event_main_related_provider.dart';
import 'providers/event/main/event_main_vote_provider.dart';
import 'providers/language_provider.dart';
import 'providers/user/user_me_provider.dart';
import 'providers/vote/vote_detail_provider.dart';
import 'providers/vote/vote_main_provider.dart';
import 'providers/vote/vote_reward_media_provider.dart';
import 'screens/store/store_main_screen.dart';
import 'screens/vote/vote_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/event/detail/event_provider.dart';
import 'providers/event/detail/event_live_provider.dart';
import 'providers/event/detail/event_vod_provider.dart';
import 'providers/notice/notice_provider.dart';
import 'providers/ticket/user_pass_provider.dart';
import 'providers/ticket/vote_ticket_provider.dart';
import 'providers/user/google_oauth_provider.dart';
import 'providers/user/user_provider.dart';
import 'package:provider/provider.dart';
import 'screens/user/login_screen.dart';
import 'screens/user/google_signup_screen.dart';
import 'screens/info/notice_screen.dart';
import 'screens/info/faq_screen.dart';
import 'screens/home/home_screen.dart';
import 'utils/dio_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/env/.env");
  await DioClient().init();

  final languageProvider = LanguageProvider();
  await languageProvider.init();

  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  final status = prefs.getString('userStatus');
  String initialRoute;

  if (userId == null) {
    initialRoute = '/login';
  } else if (status == 'NEEDS_INFO' || status == 'NEW_USER') {
    initialRoute = '/google_signup';
  } else {
    initialRoute = '/home';
  }
  final dio = DioClient().dio;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
        ChangeNotifierProvider(create: (_) => TranslationProvider()),
        ChangeNotifierProvider(create: (_) => EventMainProvider(dio)),
        ChangeNotifierProvider(create: (context) => EventProvider(dio, context.read<LanguageProvider>())),
        ChangeNotifierProvider(create: (context) => EventInfoProvider(dio, context.read<LanguageProvider>())),
        ChangeNotifierProvider(create: (context) => EventVoteProvider(dio, context.read<LanguageProvider>())),
        ChangeNotifierProvider(create: (_) => EventVODProvider(dio)),
        ChangeNotifierProvider(create: (_) => EventLiveProvider(dio)),
        ChangeNotifierProvider(create: (_) => EventMainRelatedProvider(dio)),
        ChangeNotifierProvider(create: (_) => EventRelatedProvider(dio)),
        ChangeNotifierProvider(create: (context) => NoticeProvider(dio, context.read<LanguageProvider>())),
        ChangeNotifierProvider(create: (_) => ProductKRProvider(dio)),
        ChangeNotifierProvider(create: (_) => ProductUSDProvider(dio)),
        ChangeNotifierProvider(create: (_) => VoteTicketProvider()),  // 수정 예정
        ChangeNotifierProvider(create: (_) => UserPassProvider()),  // 수정 예정
        ChangeNotifierProvider(create: (context) => VoteMainProvider(dio, context.read<LanguageProvider>())),
        ChangeNotifierProvider(create: (context) => VoteDetailProvider(dio, context.read<LanguageProvider>())),
        ChangeNotifierProvider(create: (_) => VoteAvailabilityProvider(dio)),
        ChangeNotifierProvider(create: (_) => VoteRewardMediaProvider(dio)),
        ChangeNotifierProvider(create: (_) => EventMainVoteProvider(dio)),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserMeProvider()),
        ChangeNotifierProvider(create: (_) => GoogleOauthProvider()),
      ],
      child: MyApp(initialRoute: initialRoute),
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
        '/notice': (context) => const NoticeScreen(),
        '/faq': (context) => const FAQScreen(),
        '/home': (context) => const HomeScreen(),
        '/voteMainScreen': (context) => const VoteMainScreen(),
        '/storeMainScreen': (context) => const StoreMainScreen(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/google_signup') {
          final args = settings.arguments;
          if (args is Map<String, dynamic>) {
            return MaterialPageRoute(
              builder: (context) => GoogleSignUpScreen(
                email: args['email'] ?? '',
                name: args['name'] ?? '',
              ),
            );
          } else {
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          }
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