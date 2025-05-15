import 'dart:async';
import 'package:flutter/material.dart';

class HomeBannerSection extends StatefulWidget {
  const HomeBannerSection({super.key});

  @override
  State<HomeBannerSection> createState() => _HomeBannerSectionState();
}

class _HomeBannerSectionState extends State<HomeBannerSection> {
  late String selectedImage;
  late Timer _timer;
  int currentIndex = 0;

  final List<String> bannerImages = [
    'assets/images/banner/banner1.png',
    'assets/images/banner/banner2.png',
    'assets/images/banner/banner3.png',
    'assets/images/banner/banner4.png',
    'assets/images/banner/banner5.png',
    'assets/images/banner/banner6.png',
    'assets/images/banner/banner7.png',
    'assets/images/banner/banner8.png',
  ];

  @override
  void initState() {
    super.initState();
    selectedImage = bannerImages[currentIndex];

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _setNextImage();
    });
  }

  void _setNextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % bannerImages.length;
      selectedImage = bannerImages[currentIndex];
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: Image.asset(
          selectedImage,
          key: ValueKey<String>(selectedImage),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
