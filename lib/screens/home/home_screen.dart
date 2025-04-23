import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vote/vote_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/header.dart';
import '../../widgets/home_related_video_section.dart';
import 'home_award.dart';
import 'home_banner_section.dart';
import 'home_event_profile_list.dart';
import 'home_vote.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vote = context.read<VoteProvider>().getVoteByCode('V005');

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      extendBodyBehindAppBar: true,
      appBar: const Header(isHome: true),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kToolbarHeight),
            Stack(
              children: const [
                HomeBannerSection(),
                HomeEventProfileList(),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (vote != null) HomeAward(vote: vote),
                  const SizedBox(height: 24),
                  if (vote != null) HomeAwardSection(vote: vote),
                  const SizedBox(height: 40),
                  const HomeRelatedVideoSection(),
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
