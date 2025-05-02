import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vote/vote_main_model.dart';
import '../../providers/vote/vote_main_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/vote/vote_card.dart';
import '../../widgets/vote/vote_card_for_main.dart';
import '../../widgets/vote/vote_filter_widget.dart';
import '../vote/vote_detail_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VoteMainScreen extends StatefulWidget {
  const VoteMainScreen({super.key});

  @override
  State<VoteMainScreen> createState() => _VoteMainScreenState();
}

class _VoteMainScreenState extends State<VoteMainScreen> {
  String selectedStatus = '전체';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<VoteMainProvider>().fetchVotesByStatus('all'));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VoteMainProvider>();
    final votes = provider.votes;

    return Scaffold(
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
                      text: '-Pick',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: VoteFilterWidget(
              filters: const ['전체', '진행중', '진행완료', '진행예정'],
              selectedFilter: selectedStatus,
              onChanged: (status) {
                setState(() => selectedStatus = status);
                final statusMap = {
                  '전체': 'all',
                  '진행중': 'open',
                  '진행완료': 'closed',
                  '진행예정': 'before',
                };
                context.read<VoteMainProvider>().fetchVotesByStatus(statusMap[status] ?? 'all');
              },
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                ? Center(child: Text(provider.error!, style: const TextStyle(color: Colors.red)))
                : ListView.builder(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: votes.length,
              itemBuilder: (context, index) {
                final vote = votes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: VoteCardForMain(
                    vote: vote,
                    selectedStatus: selectedStatus,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VoteDetailScreen(
                            voteCode: vote.voteCode,
                            eventName: vote.eventName,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
