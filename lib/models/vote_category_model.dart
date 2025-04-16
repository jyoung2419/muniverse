// class VoteCategoryModel {
//   final String voteCategoryCode;
//   final String name;
//   final DateTime createDate;
//   final DateTime? updateDate;
//   final bool deleteFlag;
//
//   const VoteCategoryModel({
//     required this.voteCategoryCode,
//     required this.name,
//     required this.createDate,
//     this.updateDate,
//     required this.deleteFlag,
//   });
//
//   factory VoteCategoryModel.fromJson(Map<String, dynamic> json) {
//     return VoteCategoryModel(
//       voteCategoryCode: json['voteCategoryCode'],
//       name: json['name'],
//       createDate: DateTime.parse(json['createDate']),
//       updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
//       deleteFlag: json['deleteFlag'],
//     );
//   }
// }
