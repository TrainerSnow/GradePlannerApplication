// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userpreferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      currentYear: json['currentYear'] as String,
      orderMode: json['orderMode'] as int,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'currentYear': instance.currentYear,
      'orderMode': instance.orderMode,
    };
