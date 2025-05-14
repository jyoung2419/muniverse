class UserPassModel {
  final String pinNumber;         // 이용권 PIN
  final String passName;          // 이용권 이름
  final bool useFlag;             // 사용중 여부
  final bool hasLive;             // 라이브 포함 여부
  final bool hasVod;              // VOD 포함 여부
  final String productImageUrl;   // 대표 이미지 URL
  final String productName;       // 대표 상품 이름
  final String eventName;         // 이벤트 이름
  final String type;              // LIVE 또는 VOD
  final String eventCode;         // 이벤트 코드

  UserPassModel({
    required this.pinNumber,
    required this.passName,
    required this.useFlag,
    required this.hasLive,
    required this.hasVod,
    required this.productImageUrl,
    required this.productName,
    required this.eventName,
    required this.type,
    required this.eventCode,
  });

  factory UserPassModel.fromJson(Map<String, dynamic> json) {
    return UserPassModel(
      pinNumber: json['pinNumber'] ?? '',
      passName: json['passName'] ?? '',
      useFlag: json['useFlag'] ?? false,
      hasLive: json['hasLive'] ?? false,
      hasVod: json['hasVod'] ?? false,
      productImageUrl: json['productImageUrl'] ?? '',
      productName: json['productName'] ?? '',
      eventName: json['eventName'] ?? '',
      type: json['type'] ?? '',
      eventCode: json['eventCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pinNumber': pinNumber,
      'passName': passName,
      'useFlag': useFlag,
      'hasLive': hasLive,
      'hasVod': hasVod,
      'productImageUrl': productImageUrl,
      'productName': productName,
      'eventName': eventName,
      'type': type,
      'eventCode': eventCode,
    };
  }
}
