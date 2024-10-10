// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppParams _$AppParamsFromJson(Map<String, dynamic> json) => AppParams(
      uid: json['u_id'] as String?,
      appId: json['app_id'] as String,
      appVersion: json['app_version'] as String,
      locale: json['locale'] as String,
      idfa: json['idfa'] as String,
      fcmToken: json['fcm_token'] as String,
      os: json['os'] as String,
      osVersion: json['os_version'] as String,
      deviceGeneration: json['device_generation'] as String,
      deviceName: json['device_name'] as String,
      deviceModel: json['device_model'] as String,
      deviceWidth: (json['device_width'] as num).toDouble(),
      deviceHeight: (json['device_height'] as num).toDouble(),
    )
      ..fbAttribution = json['fb_at'] as String?
      ..devKey = json['dev_key'] as String?
      ..bundle = json['bundle'] as String?
      ..fbApplicationId = json['fb_app_id'] as String?;

Map<String, dynamic> _$AppParamsToJson(AppParams instance) => <String, dynamic>{
      'u_id': instance.uid,
      'app_id': instance.appId,
      'app_version': instance.appVersion,
      'locale': instance.locale,
      'idfa': instance.idfa,
      'fcm_token': instance.fcmToken,
      'os': instance.os,
      'os_version': instance.osVersion,
      'device_generation': instance.deviceGeneration,
      'device_name': instance.deviceName,
      'device_model': instance.deviceModel,
      'device_width': instance.deviceWidth,
      'device_height': instance.deviceHeight,
      'fb_at': instance.fbAttribution,
      'dev_key': instance.devKey,
      'bundle': instance.bundle,
      'fb_app_id': instance.fbApplicationId,
    };
