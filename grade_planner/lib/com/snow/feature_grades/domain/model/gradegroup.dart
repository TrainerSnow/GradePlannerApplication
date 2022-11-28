import 'package:grade_planner/com/snow/feature_grades/domain/model/grade.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gradegroup.g.dart';

@JsonSerializable(explicitToJson: true)
class GradeGroup {
  String name;

  List<Grade> grades;

  double part;

  double average() {
    double sum = 0;

    for (Grade g in grades) {
      sum += g.value;
    }

    var avg = sum / grades.length;
    if (avg == double.nan) {
      return 0;
    } else {
      return avg;
    }
  }

  GradeGroup({required this.name, required this.part, required this.grades});

  factory GradeGroup.fromJson(Map<String, dynamic> json) => _$GradeGroupFromJson(json);

  Map<String, dynamic> toJson() => _$GradeGroupToJson(this);

  @override
  bool operator ==(Object other) => identical(this, other) || other is GradeGroup && runtimeType == other.runtimeType && name == other.name && grades == other.grades && part == other.part;

  @override
  int get hashCode => name.hashCode ^ grades.hashCode ^ part.hashCode;
}
