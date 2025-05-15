class ImagePopup {
  final String popupName;
  final String popupImageUrl;

  ImagePopup({
    required this.popupName,
    required this.popupImageUrl,
  });

  factory ImagePopup.fromJson(Map<String, dynamic> json) {
    return ImagePopup(
      popupName: json['popupName'] ?? '',
      popupImageUrl: json['popupImageUrl'] ?? '',
    );
  }
}

class TextPopup {
  final String popupTitle;
  final String popupContent;
  final String popupContentEn;

  TextPopup({
    required this.popupTitle,
    required this.popupContent,
    required this.popupContentEn,
  });

  factory TextPopup.fromJson(Map<String, dynamic> json) {
    return TextPopup(
      popupTitle: json['popupTitle'] ?? '',
      popupContent: json['popupContent'] ?? '',
      popupContentEn: json['popupContentEn'] ?? '',
    );
  }
}

class PopupListResponse {
  final List<ImagePopup> imagePopups;
  final List<TextPopup> textPopups;

  PopupListResponse({
    required this.imagePopups,
    required this.textPopups,
  });

  factory PopupListResponse.fromJson(Map<String, dynamic> json) {
    return PopupListResponse(
      imagePopups: (json['imagePopups'] as List?)
          ?.map((e) => ImagePopup.fromJson(e))
          .toList() ??
          [],
      textPopups: (json['textPopups'] as List?)
          ?.map((e) => TextPopup.fromJson(e))
          .toList() ??
          [],
    );
  }
}
