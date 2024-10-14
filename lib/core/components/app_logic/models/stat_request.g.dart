// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatRequest _$StatRequestFromJson(Map<String, dynamic> json) => StatRequest(
      uid: json['u_id'] as String,
      type: json['type'] as String,
      urls: (json['urls'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$StatRequestToJson(StatRequest instance) =>
    <String, dynamic>{
      'u_id': instance.uid,
      'type': instance.type,
      'urls': instance.urls,
    };
