// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Year _$YearFromJson(Map<String, dynamic> json) => Year(
      name: json['name'] as String,
      subjects: (json['subjects'] as List<dynamic>).map((e) => Subject.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$YearToJson(Year instance) => <String, dynamic>{
      'name': instance.name,
      'subjects': instance.subjects.map((e) => e.toJson()).toList(),
    };
