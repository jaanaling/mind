import 'package:json_annotation/json_annotation.dart';

part 'web_view_data.g.dart';

@JsonSerializable()
class CoreData {
  final bool ok;
  final Result result;

  CoreData({
    required this.ok,
    required this.result,
  });

  factory CoreData.fromJson(Map<String, dynamic> json) =>
      _$CoreDataFromJson(json);

  Map<String, dynamic> toJson() => _$CoreDataToJson(this);
}

@JsonSerializable()
class Result {
  @JsonKey(name: 'u_id')
  final String uid;

  @JsonKey(name: 'target_url')
  final String targetUrl;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'is_send_events_af')
  final bool isSendEventsAf;

  @JsonKey(name: 'background_color')
  final String backgroundColor;

  @JsonKey(name: 'is_notch_enabled')
  final bool isNotchEnabled;

  @JsonKey(name: 'is_nav_bar_enabled')
  final bool isNavBarEnabled;

  @JsonKey(name: 'is_send_events_facebook')
  final bool isSendEventsFacebook;

  @JsonKey(name: 'is_wait_appsflyer')
  final bool isWaitAppsflyer;

  Result({
    required this.uid,
    required this.targetUrl,
    required this.isActive,
    required this.isSendEventsAf,
    required this.backgroundColor,
    required this.isNotchEnabled,
    required this.isNavBarEnabled,
    required this.isSendEventsFacebook,
    required this.isWaitAppsflyer,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
