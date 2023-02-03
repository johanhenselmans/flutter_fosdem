// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conference _$ConferenceFromJson(Map json) => Conference(
      json['title'] as String?,
      json['subtitle'] as String?,
      json['start'] as String?,
      end: json['end'] as String?,
      venue: json['venue'] as String?,
      city: json['city'] as String?,
    )
      ..days = json['days'] as int?
      ..day_change = json['day_change'] as String?
      ..timeslot_duration = json['timeslot_duration'] as String?
      ..year = json['year'] as int?
      ..eventsdownloaded = json['eventsdownloaded'] as String;

Map<String, dynamic> _$ConferenceToJson(Conference instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'venue': instance.venue,
      'city': instance.city,
      'start': instance.start,
      'end': instance.end,
      'days': instance.days,
      'day_change': instance.day_change,
      'timeslot_duration': instance.timeslot_duration,
      'year': instance.year,
      'eventsdownloaded': instance.eventsdownloaded,
    };
