import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/payment/user_payment_provider.dart';
import 'providers/product/event_product_kr_provider.dart';
import 'providers/product/event_product_usd_provider.dart';
import 'providers/product/product_detail_provider.dart';
import 'providers/translation_provider.dart';
import 'providers/reward/reward_provider.dart';
import 'providers/user/twitter_oauth_provider.dart';
import 'providers/user/user_profile_provider.dart';
import 'providers/vote/vote_availability_provider.dart';
import 'providers/event/detail/event_info_provider.dart';
import 'providers/event/detail/event_vote_provider.dart';
import 'providers/language_provider.dart';
import 'providers/user/user_me_provider.dart';
import 'providers/vote/vote_detail_provider.dart';
import 'providers/vote/vote_main_provider.dart';
import 'providers/vote/vote_reward_media_provider.dart';
import 'screens/product/product_main_screen.dart';
import 'screens/user/twitter_signup_screen.dart';
import 'screens/vote/vote_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/event/detail/event_provider.dart';
import 'providers/notice/notice_provider.dart';
import 'providers/ticket/user_pass_provider.dart';
import 'providers/ticket/vote_ticket_provider.dart';
import 'providers/user/google_oauth_provider.dart';
import 'providers/user/user_provider.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'screens/user/login_screen.dart';
import 'screens/user/google_signup_screen.dart';
import 'screens/info/notice_screen.dart';
import 'screens/info/faq_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/order/order_service.dart';
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
    ProviderScope(
      child: legacy_provider.MultiProvider(
        providers: [
        legacy_provider.ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
        legacy_provider.ChangeNotifierProvider(create: (_) => TranslationProvider()),
        legacy_provider.ChangeNotifierProvider(create: (context) => EventProvider(dio, context.read<LanguageProvider>())),
        legacy_provider.ChangeNotifierProvider(create: (context) => EventInfoProvider(dio, context.read<LanguageProvider>())),
        legacy_provider.ChangeNotifierProvider(create: (context) => EventProductKRProvider(dio, context.read<LanguageProvider>())),
        legacy_provider.ChangeNotifierProvider(create: (context) => EventProductUSDProvider(dio, context.read<LanguageProvider>())),
        legacy_provider.ChangeNotifierProvider(create: (context) => EventVoteProvider(dio, context.read<LanguageProvider>())),
        legacy_provider.ChangeNotifierProvider(create: (context) => NoticeProvider(dio, context.read<LanguageProvider>())),
        legacy_provider.ChangeNotifierProvider(create: (context) => ProductDetailProvider(dio, context.read<LanguageProvider>())),
        legacy_provider.ChangeNotifierProvider(create: (_) => VoteTicketProvider()),
        legacy_provider.ChangeNotifierProvider(create: (context) => UserPassProvider(dio, context.read<LanguageProvider>())),
        legacy_provider.ChangeNotifierProvider(create: (context) => VoteMainProvider(dio, context.read<LanguageProvider>())),
        legacy_provider.ChangeNotifierProvider(create: (context) => VoteDetailProvider(dio, context.read<LanguageProvider>())),
        legacy_provider.ChangeNotifierProvider(create: (_) => VoteAvailabilityProvider(dio)),
        legacy_provider.ChangeNotifierProvider(create: (_) => VoteRewardMediaProvider(dio)),
        legacy_provider.ChangeNotifierProvider(create: (_) => UserProvider()),
        legacy_provider.ChangeNotifierProvider(create: (_) => UserMeProvider()),
        legacy_provider.ChangeNotifierProvider(create: (context) => UserProfileProvider(dio)),
        legacy_provider.ChangeNotifierProvider(create: (context) => UserPaymentProvider(dio)),
        legacy_provider.ChangeNotifierProvider(create: (context) => RewardProvider(dio, context.read<LanguageProvider>())),
        legacy_provider.ChangeNotifierProvider(create: (_) => GoogleOauthProvider()),
        legacy_provider.ChangeNotifierProvider(create: (_) => TwitterOauthProvider()),
      ],
      child: MyApp(initialRoute: initialRoute),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _setupDeepLinkListener();
  }

  Future<void> _setupDeepLinkListener() async {
    _appLinks = AppLinks();
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {
        print('✅ 딥링크 수신: $uri');
        final oauthToken = uri.queryParameters['oauth_token'];
        final oauthVerifier = uri.queryParameters['oauth_verifier'];

        if (oauthToken != null && oauthVerifier != null) {
          final provider = legacy_provider.Provider.of<TwitterOauthProvider>(context, listen: false);
          await provider.completeServerLogin(context, oauthToken, oauthVerifier);
        }
      }
    }, onError: (err) {
      print('딥링크 에러: $err');
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'muniverse',
      theme: ThemeData(fontFamily: "Pretendard"),
      initialRoute: widget.initialRoute,

      routes: {
        '/login': (context) => const LoginScreen(),
        '/notice': (context) => const NoticeScreen(),
        '/faq': (context) => const FAQScreen(),
        '/home': (context) => const HomeScreen(),
        '/voteMainScreen': (context) => const VoteMainScreen(),
        '/productMainScreen': (context) => const ProductMainScreen(),
      },

      onGenerateRoute: (settings) {

        print('💡 onGenerateRoute called with: ${settings.name}');
        final args = settings.arguments;
        print('💡 arguments: $args');

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
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          }
        }

        if (settings.name == '/twitter_signup') {
          print('💡 트위터 라우트 진입');
          if (args is Map) {
            return MaterialPageRoute(
              builder: (context) => TwitterSignUpScreen(
                userId: args['userId'] ?? '',
                name: args['name'] ?? '',
              ),
            );
          } else {
            print('💡 arguments 타입 오류 → 로그인으로 fallback');
            return MaterialPageRoute(builder: (context) => const LoginScreen());
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