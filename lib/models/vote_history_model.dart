// class VoteHistoryModel {
//   final int seq;
//   final String userId;
//   final String voteCode;
//   final DateTime createDate;
//
//   const VoteHistoryModel({
//     required this.seq,
//     required this.userId,
//     required this.voteCode,
//     required this.createDate,
//   });
//
//   factory VoteHistoryModel.fromJson(Map<String, dynamic> json) {
//     return VoteHistoryModel(
//       seq: json['seq'],
//       userId: json['userId'],
//       voteCode: json['vote']['voteCode'], // nested object handling
//       createDate: DateTime.parse(json['createDate']),
//     );
//   }
// }