// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      json['title'],
      event_id: json['event id'],
      start: json['start'],
      duration: json['duration'],
      room: json['room'],
      slug: json['slug'],
      subtitle: json['subtitle'],
      track: json['track'],
      type: json['type'],
      language: json['language'],
      abstract: json['abstract'],
      description: json['description'],
      persons: json['persons'],
      attachments: json['attachments'],
      links: json['links'],
      year: json['year'],
    )..eventdate = json['eventdate'] as String?;

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'event id': instance.event_id,
      'start': instance.start,
      'duration': instance.duration,
      'room': instance.room,
      'slug': instance.slug,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'track': instance.track,
      'type': instance.type,
      'language': instance.language,
      'abstract': instance.abstract,
      'description': instance.description,
      'persons': instance.persons,
      'attachments': instance.attachments,
      'links': instance.links,
      'year': instance.year,
      'eventdate': instance.eventdate,
    };
