// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gradegroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradeGroup _$GradeGroupFromJson(Map<String, dynamic> json) => GradeGroup(
      name: json['name'] as String,
      part: (json['part'] as num).toDouble(),
      grades: (json['grades'] as List<dynamic>)
          .map((e) => Grade.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GradeGroupToJson(GradeGroup instance) =>
    <String, dynamic>{
      'name': instance.name,
      'grades': instance.grades.map((e) => e.toJson()).toList(),
      'part': instance.part,
    };
