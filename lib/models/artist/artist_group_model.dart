import 'artist_model.dart';

class ArtistGroupModel {
  final int seq;
  final ArtistModel group;  // 그룹 아티스트
  final ArtistModel member; // 멤버 아티스트
  final DateTime createDate;

  const ArtistGroupModel({
    required this.seq,
    required this.group,
    required this.member,
    required this.createDate,
  });

  factory ArtistGroupModel.fromJson(Map<String, dynamic> json) {
    return ArtistGroupModel(
      seq: json['seq'],
      group: ArtistModel.fromJson(json['group']),
      member: ArtistModel.fromJson(json['member']),
      createDate: DateTime.parse(json['createDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'group': group.toJson(),
      'member': member.toJson(),
      'createDate': createDate.toIso8601String(),
    };
  }
}
