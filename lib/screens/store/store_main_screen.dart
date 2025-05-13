import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/product/product_usd_provider.dart';
import '../../widgets/common/translate_text.dart';
import 'ticket_tab.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';

class StoreMainScreen extends StatefulWidget {
  const StoreMainScreen({super.key});

  @override
  State<StoreMainScreen> createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProductUSDProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0C0C),
        appBar: const Header(),
        endDrawer: const AppDrawer(),
        floatingActionButton: const BackFAB(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Transform.translate(
                          offset: const Offset(1, -2),
                          child: SvgPicture.asset(
                            'assets/svg/m_logo.svg',
                            height: 26,
                          ),
                        ),
                      ),
                      const TextSpan(
                        text: '- STORE',
                        style: TextStyle(
                          color: Color(0xFF2EFFAA),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26),
            // 탭바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                labelColor: const Color(0xFF2EFFAA),
                unselectedLabelColor: Colors.white,
                indicatorColor: const Color(0xFF2EFFAA),
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                dividerColor: const Color(0xFF0B0C0C),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                ),
                tabs: [
                  Tab(text: lang == 'kr' ? '티켓' : 'TICKET'),
                  Tab(text: lang == 'kr' ? '굿즈' : 'MD'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  const TicketTab(),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: TranslatedText(
                        '🎫 굿즈 상품은 추후 추가될 예정입니다.\n조금만 기다려주세요!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
