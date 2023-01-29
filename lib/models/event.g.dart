// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      json['title'] as String,
      event_id: json['event id'] as int?,
      start: json['start'] as String?,
      duration: json['duration'] as String?,
      room: json['room'] as String?,
      slug: json['slug'] as String?,
      subtitle: json['subtitle'] as String?,
      track: json['track'] as String?,
      type: json['type'] as String?,
      language: json['language'] as String?,
      abstract: json['abstract'] as String?,
      description: json['description'] as String?,
      persons: json['persons'] as Map<String, dynamic>?,
      attachments: json['attachments'] as Map<String, dynamic>?,
      links: json['links'] as Map<String, dynamic>?,
      year: json['Year'] as int?,
    );

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
      'Year': instance.year,
    };
