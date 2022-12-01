// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subject _$SubjectFromJson(Map<String, dynamic> json) => Subject(
      name: json['name'] as String,
      groups: (json['groups'] as List<dynamic>).map((e) => GradeGroup.fromJson(e as Map<String, dynamic>)).toList(),
      createdAt: json['createdAt'] as int,
      changedAt: json['changedAt'] as int,
    );

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
      'name': instance.name,
      'groups': instance.groups.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt,
      'changedAt': instance.changedAt,
    };
