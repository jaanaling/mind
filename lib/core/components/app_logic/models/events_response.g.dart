// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventsResponse _$EventsResponseFromJson(Map<String, dynamic> json) =>
    EventsResponse(
      ok: json['ok'] as bool,
      result: Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventsResponseToJson(EventsResponse instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'result': instance.result,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      events: (json['events'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'events': instance.events,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      date: json['date'] as String,
      event: json['event'] as String,
      currency: json['currency'] as String?,
      sum: (json['sum'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'date': instance.date,
      'event': instance.event,
      'currency': instance.currency,
      'sum': instance.sum,
    };
