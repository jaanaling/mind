import 'package:json_annotation/json_annotation.dart';

part 'stat_request.g.dart';

@JsonSerializable()
class StatRequest {
  @JsonKey(name: 'u_id')
  final String uid;

  final String type;
  final List<String> urls;

  StatRequest({
    required this.uid,
    required this.type,
    required this.urls,
  });

  factory StatRequest.fromJson(Map<String, dynamic> json) =>
      _$StatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StatRequestToJson(this);
}
