import 'package:json_annotation/json_annotation.dart';

part 'attribute.g.dart';

@JsonSerializable()
class Attribute {
  @JsonKey(name: 'u_id')
  final String? uid;

  @JsonKey(name: 'appsflyer_id')
  final String? appsflyerId;

  final String? idfa;

  @JsonKey(name: 'fcm_token')
  final String? fcmToken;

  Attribute({
    required this.uid,
    required this.appsflyerId,
    required this.idfa,
    required this.fcmToken,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) =>
      _$AttributeFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeToJson(this);
}
