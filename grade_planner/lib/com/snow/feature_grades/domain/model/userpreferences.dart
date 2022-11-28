import 'package:json_annotation/json_annotation.dart';

part 'userpreferences.g.dart';

@JsonSerializable()
class UserPreferences{
  String currentYear;
  int orderMode;

  UserPreferences({required this.currentYear, required this.orderMode});

  factory UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserPreferences && runtimeType == other.runtimeType && currentYear == other.currentYear && orderMode == other.orderMode;

  @override
  int get hashCode => currentYear.hashCode ^ orderMode.hashCode;

  UserPreferences copyWith({
    String? currentYear,
    int? orderMode,
  }) {
    return UserPreferences(
      currentYear: currentYear ?? this.currentYear,
      orderMode: orderMode ?? this.orderMode,
    );
  }
}