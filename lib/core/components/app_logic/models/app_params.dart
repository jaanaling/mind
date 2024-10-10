import 'package:json_annotation/json_annotation.dart';

part 'app_params.g.dart';

@JsonSerializable()
class AppParams {
  @JsonKey(name: 'u_id')
  String? uid;

  @JsonKey(name: 'app_id')
  final String appId;

  @JsonKey(name: 'app_version')
  final String appVersion;

  final String locale;
  final String idfa;

  @JsonKey(name: 'fcm_token')
  final String fcmToken;

  final String os;

  @JsonKey(name: 'os_version')
  final String osVersion;

  @JsonKey(name: 'device_generation')
  final String deviceGeneration;

  @JsonKey(name: 'device_name')
  final String deviceName;

  @JsonKey(name: 'device_model')
  final String deviceModel;

  @JsonKey(name: 'device_width')
  final double deviceWidth;

  @JsonKey(name: 'device_height')
  final double deviceHeight;

  @JsonKey(name: 'fb_at')
  String? fbAttribution;

  @JsonKey(name: 'dev_key')
  String? devKey;

  String? bundle;

  @JsonKey(name: 'fb_app_id')
  String? fbApplicationId;

  AppParams({
    required this.uid,
    required this.appId,
    required this.appVersion,
    required this.locale,
    required this.idfa,
    required this.fcmToken,
    required this.os,
    required this.osVersion,
    required this.deviceGeneration,
    required this.deviceName,
    required this.deviceModel,
    required this.deviceWidth,
    required this.deviceHeight,
  });

  factory AppParams.fromJson(Map<String, dynamic> json) =>
      _$AppParamsFromJson(json);

  Map<String, dynamic> toJson() => _$AppParamsToJson(this);
}
