// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_view_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoreData _$CoreDataFromJson(Map<String, dynamic> json) => CoreData(
      ok: json['ok'] as bool,
      result: Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CoreDataToJson(CoreData instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'result': instance.result,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      uid: json['u_id'] as String,
      targetUrl: json['target_url'] as String,
      isActive: json['is_active'] as bool,
      isSendEventsAf: json['is_send_events_af'] as bool,
      backgroundColor: json['background_color'] as String,
      isNotchEnabled: json['is_notch_enabled'] as bool,
      isNavBarEnabled: json['is_nav_bar_enabled'] as bool,
      isSendEventsFacebook: json['is_send_events_facebook'] as bool,
      isWaitAppsflyer: json['is_wait_appsflyer'] as bool,
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'u_id': instance.uid,
      'target_url': instance.targetUrl,
      'is_active': instance.isActive,
      'is_send_events_af': instance.isSendEventsAf,
      'background_color': instance.backgroundColor,
      'is_notch_enabled': instance.isNotchEnabled,
      'is_nav_bar_enabled': instance.isNavBarEnabled,
      'is_send_events_facebook': instance.isSendEventsFacebook,
      'is_wait_appsflyer': instance.isWaitAppsflyer,
    };
