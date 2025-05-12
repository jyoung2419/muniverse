import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event/detail/event_vote_model.dart';
import '../models/event/main/event_main_vote_model.dart';
import '../models/vote/vote_detail_content_model.dart';
import '../providers/language_provider.dart';

class VoteTextUtil {
  static Map<String, String> getLabelsForEventVote(BuildContext context, EventVoteModel vote) {
    final lang = context.read<LanguageProvider>().selectedLanguageCode;

    String getDateRange(DateTime start, DateTime end) {
      final formatter = DateFormat('yyyy.MM.dd');
      return '${formatter.format(start)} ~ ${formatter.format(end)}';
    }

    return {
      'vote_upcoming': lang == 'kr' ? '투표 예정' : 'UPCOMING',
      'vote_result': lang == 'kr' ? '결과 보기' : 'RESULT',
      'vote_ongoing': lang == 'kr' ? '진행중' : 'ONGOING',
      'vote_closed': lang == 'kr' ? '진행완료' : 'CLOSED',
      'vote_vote': lang == 'kr' ? '투표하기' : 'VOTE',
      'vote_remaining': lang == 'kr' ? '남은 투표기간 ${vote.voteRestDay}일' : 'D-${vote.voteRestDay}',
      'vote_period': lang == 'kr'
          ? '기간 : ${getDateRange(vote.startTime, vote.endTime)} (KST)'
          : 'Period : ${getDateRange(vote.startTime, vote.endTime)} (KST)',
      'vote_reward': lang == 'kr' ? '리워드' : 'REWARD',
      'vote_reward_empty': lang == 'kr' ? '리워드 정보 없음' : 'No reward info',
    };
  }

  static Map<String, String> getLabelsForMainVote(BuildContext context, EventMainVoteModel vote) {
    final lang = context.read<LanguageProvider>().selectedLanguageCode;

    return {
      'vote_ongoing': lang == 'kr' ? '진행중' : 'ONGOING',
      'vote_remaining': lang == 'kr'
          ? '남은 투표기간 ${vote.voteRestDay}일'
          : 'D-${vote.voteRestDay}',
      'vote_reward_empty': lang == 'kr' ? '리워드 정보 없음' : 'No reward info',
    };
  }

  static Map<String, String> getLabelsForDetailContent(BuildContext context, VoteDetailContentModel vote) {
    final lang = context.read<LanguageProvider>().selectedLanguageCode;

    String getDateRange(DateTime start, DateTime end) {
      final formatter = DateFormat('yyyy.MM.dd');
      return '${formatter.format(start)} ~ ${formatter.format(end)}';
    }

    return {
      'vote_upcoming': lang == 'kr' ? '투표 예정' : 'UPCOMING',
      'vote_result': lang == 'kr' ? '결과 보기' : 'RESULT',
      'vote_ongoing': lang == 'kr' ? '진행중' : 'ONGOING',
      'vote_closed': lang == 'kr' ? '진행완료' : 'CLOSED',
      'vote_vote': lang == 'kr' ? '투표하기' : 'VOTE',
      'vote_remaining': lang == 'kr' ? '남은 투표기간 ${vote.voteRestDay}일' : 'D-${vote.voteRestDay}',
      'vote_period': lang == 'kr'
          ? '기간 : ${getDateRange(vote.startTime, vote.endTime)} (KST)'
          : 'Period : ${getDateRange(vote.startTime, vote.endTime)} (KST)',
      'vote_reward': lang == 'kr' ? '리워드' : 'REWARD',
      'vote_reward_empty': lang == 'kr' ? '리워드 정보 없음' : 'No reward info',
    };
  }
}
