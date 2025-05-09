class VoteResponseModel {
  final bool success;
  final String message;

  VoteResponseModel({required this.success, required this.message});

  factory VoteResponseModel.fromJson(Map<String, dynamic> json) {
    return VoteResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
