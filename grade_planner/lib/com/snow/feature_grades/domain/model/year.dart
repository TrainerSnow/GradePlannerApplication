import 'package:grade_planner/com/snow/feature_grades/domain/model/subject.dart';
import 'package:json_annotation/json_annotation.dart';

part 'year.g.dart';

@JsonSerializable(explicitToJson: true)
class Year {
  String name;
  List<Subject> subjects;

  Year({required this.name, required this.subjects});

  factory Year.fromJson(Map<String, dynamic> json) => _$YearFromJson(json);

  Map<String, dynamic> toJson() => _$YearToJson(this);

  @override
  bool operator ==(Object other) => identical(this, other) || other is Year && runtimeType == other.runtimeType && name == other.name && subjects == other.subjects;

  @override
  int get hashCode => name.hashCode ^ subjects.hashCode;
}
