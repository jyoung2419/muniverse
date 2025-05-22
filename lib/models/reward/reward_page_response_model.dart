import 'reward_item_model.dart';

class RewardPageResponse {
  final List<RewardItemModel> content;
  final int totalPages;
  final int totalElements;
  final int number;
  final bool last;

  RewardPageResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.number,
    required this.last,
  });

  factory RewardPageResponse.fromJson(Map<String, dynamic> json) {
    return RewardPageResponse(
      content: (json['content'] as List)
          .map((e) => RewardItemModel.fromJson(e))
          .toList(),
      totalPages: json['totalPages'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      number: json['number'] ?? 0,
      last: json['last'] ?? true,
    );
  }
}
