// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attribute _$AttributeFromJson(Map<String, dynamic> json) => Attribute(
      uid: json['u_id'] as String?,
      appsflyerId: json['appsflyer_id'] as String?,
      idfa: json['idfa'] as String?,
      fcmToken: json['fcm_token'] as String?,
    );

Map<String, dynamic> _$AttributeToJson(Attribute instance) => <String, dynamic>{
      'u_id': instance.uid,
      'appsflyer_id': instance.appsflyerId,
      'idfa': instance.idfa,
      'fcm_token': instance.fcmToken,
    };
