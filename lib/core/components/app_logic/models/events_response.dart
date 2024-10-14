import 'package:json_annotation/json_annotation.dart';

part 'events_response.g.dart';

@JsonSerializable()
class EventsResponse {
  final bool ok;
  final Result result;

  EventsResponse({
    required this.ok,
    required this.result,
  });

  factory EventsResponse.fromJson(Map<String, dynamic> json) =>
      _$EventsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventsResponseToJson(this);
}

@JsonSerializable()
class Result {
  final List<Event> events;

  Result({
    required this.events,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Event {
  final String date;
  final String event;
  final String? currency;
  final double? sum;

  Event({
    required this.date,
    required this.event,
    this.currency,
    this.sum,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
