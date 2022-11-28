// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Grade _$GradeFromJson(Map<String, dynamic> json) => Grade(
      value: (json['value'] as num).toDouble(),
      name: json['name'] as String,
      createdAt: json['createdAt'] as int,
      groupName: json['groupName'] as String,
      subjectName: json['subjectName'] as String,
      numPhotos: json['numPhotos'] as int,
    );

Map<String, dynamic> _$GradeToJson(Grade instance) => <String, dynamic>{
      'value': instance.value,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'numPhotos': instance.numPhotos,
      'groupName': instance.groupName,
      'subjectName': instance.subjectName,
    };
