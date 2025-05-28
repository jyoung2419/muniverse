import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/event/main/event_main_model.dart';
import '../title/title_home_screen.dart';

class HomeBannerSection extends StatefulWidget {
  final List<EventMainModel> events;
  const HomeBannerSection({super.key, required this.events});

  @override
  State<HomeBannerSection> createState() => _HomeBannerSectionState();
}

class _HomeBannerSectionState extends State<HomeBannerSection> {
  late final PageController _pageController;
  late Timer _timer;

  int currentPage = 1;

  final List<String> bannerImages = [
    'assets/images/banner/Mokpo.png',
    'assets/images/banner/BUSAN.png',
    'assets/images/banner/The_Fillin_Live.png',
    'assets/images/banner/SHOW_MUSIC_CORE.png',
    'assets/images/banner/its_live.png',
    'assets/images/banner/Idol_Star.png',
    'assets/images/banner/MBC_Music_Festival.png',
  ];

  final List<String> bannerEventCodes = [
    '6334bed1-c6f2-47ab-8c1c-e73c124f8496',
    'b5d3c1b7-b1f9-45a4-9bb3-6ad5663bf48e',
    '0264a0cb-24fe-4407-8fa8-ce45c90028ec',
    'a038a16a-cdd3-49ff-9d9a-9eb1f87c374a',
    'a4d54e27-b2aa-4e28-b029-fab1243a511a',
    'c9a21436-1b61-42e1-a942-d80d6df74251',
    '35710589-1f14-47b2-a199-9611ae085a3a',
  ];

  List<String> get loopedImages =>
      [bannerImages.last, ...bannerImages, bannerImages.first];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onTapBanner() {
    final index = (currentPage - 1) % bannerEventCodes.length;
    final eventCode = bannerEventCodes[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TitleHomeScreen(eventCode: eventCode),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });

    if (index == 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _pageController.jumpToPage(bannerImages.length);
      });
    } else if (index == bannerImages.length + 1) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _pageController.jumpToPage(1);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.6;

    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GestureDetector(
            onTap: _onTapBanner,
            child: PageView.builder(
              controller: _pageController,
              itemCount: loopedImages.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (_, index) {
                final img = loopedImages[index];
                return Image.asset(
                  img,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                );
              },
            ),
          ),
          Positioned(
            bottom: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(bannerImages.length, (index) {
                final isActive = currentPage == index + 1;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 10 : 6,
                  height: isActive ? 10 : 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? Colors.white : Colors.white38,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
