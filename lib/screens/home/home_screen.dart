import 'package:flutter/material.dart';
import '../../providers/candidate_provider.dart';
import '../../widgets/common/app_drawer.dart';
import 'home_award_timer.dart';
import 'home_candidate_list.dart';
import 'home_vote_progress.dart';
import '../../widgets/common/header.dart';
import 'home_banner_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      extendBodyBehindAppBar: true,
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kToolbarHeight),
            const HomeBannerCarousel(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const HomeAwardTimer(),
                  const SizedBox(height: 24),
                  HomeCandidateList(candidates: candidates),
                  const SizedBox(height: 24),
                  HomeVoteProgress(
                    progress: 0.74,
                    remainingTime: 'D-2',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
