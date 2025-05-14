import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/reward/reward_item_model.dart';
import '../../providers/reward/reward_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/dotted_divider.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/mypage/reward_expired_dialog.dart';
import '../../widgets/mypage/reward_fail_dialog.dart';
import '../../widgets/mypage/reward_form_modal.dart';

class RewardHistoryScreen extends StatefulWidget {
  const RewardHistoryScreen({super.key});

  @override
  State<RewardHistoryScreen> createState() => _RewardHistoryScreenState();
}

class _RewardHistoryScreenState extends State<RewardHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RewardProvider>().fetchRewards();
    });
  }

  String formatDateWithWeekday(DateTime date) {
    final weekKor = ['월', '화', '수', '목', '금', '토', '일'];
    return '${date.month}/${date.day}(${weekKor[date.weekday - 1]})';
  }

  @override
  Widget build(BuildContext context) {
    final rewards = context.watch<RewardProvider>().rewards;
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final countText = lang == 'kr'
        ? '총 ${rewards.length}건'
        : 'Total ${rewards.length} Cases';
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: rewards.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight + 24),
          child: TranslatedText(
            '당첨 내역이 없습니다.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Text(
                lang == 'kr' ? '당첨 내역' : 'WINNING EVENT',
                style: const TextStyle(
                  color: Color(0xFF2EFFAA),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(countText,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                itemCount: rewards.length,
                separatorBuilder: (_, __) =>
                const Divider(color: Colors.white12),
                  itemBuilder: (context, index) {
                    final reward = rewards[index];
                    final status = reward.rewardStatusEnum;

                    late final String buttonLabel;
                    late final bool isActive;

                    switch (status) {
                      case RewardStatus.DRAWN:
                      case RewardStatus.REGISTERED:
                        buttonLabel = lang == 'kr' ? '준비중' : 'PREPARING';
                        isActive = false;
                        break;
                      case RewardStatus.COLLECTING_INFO:
                        buttonLabel = lang == 'kr' ? '당첨 내역 확인' : 'CHECK REWARD';
                        isActive = true;
                        break;
                      case RewardStatus.INFORMED:
                      case RewardStatus.CLOSED:
                      default:
                        buttonLabel = lang == 'kr' ? '종료' : 'END';
                        isActive = false;
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            reward.voteProfileImageURL,
                            width: 160,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TranslatedText(
                                '[투표] ${reward.voteName}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TranslatedText(
                                '${formatDateWithWeekday(reward.voteOpenDate)} ~ ${formatDateWithWeekday(reward.voteCloseDate)}',
                                style: const TextStyle(fontSize: 13, color: Colors.white60),
                              ),
                              const SizedBox(height: 8),
                              DottedDivider(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: isActive
                                    ? ElevatedButton(
                                  onPressed: () async {
                                    final result = await context.read<RewardProvider>().fetchRewardCheck(reward.rewardCode);
                                    final bool isWinner = result['winner'] == true;
                                    final bool canSubmitInfo = result['canSubmitInfo'] == true;

                                    if (!isWinner) {
                                      showDialog(context: context, builder: (_) => const RewardFailDialog());
                                    } else if (isWinner && !canSubmitInfo) {
                                      showDialog(context: context, builder: (_) => const RewardExpiredDialog());
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (_) => RewardFormModal(rewardCode: reward.rewardCode),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2EFFAA),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    minimumSize: const Size(65, 30),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    buttonLabel,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                                  ),
                                )
                                    : ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0x66B0B0B0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    minimumSize: const Size(60, 30),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    buttonLabel,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF171719),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
