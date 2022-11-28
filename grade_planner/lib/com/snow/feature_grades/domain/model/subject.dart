import 'package:json_annotation/json_annotation.dart';

import '../../../di/injecting.dart';
import 'grade.dart';
import 'gradegroup.dart';

part 'subject.g.dart';

@JsonSerializable(explicitToJson: true)
class Subject {
  String name;
  List<GradeGroup> groups;
  int createdAt;
  int changedAt;

  double average() {
    double sum = 0;

    var actualGroups = groups.where((element) => element.grades.isNotEmpty);
    double actual100Percent = 0;
    actualGroups.forEach((element) {
      actual100Percent += element.part;
    });

    for(GradeGroup group in actualGroups){
      double groupSum = 0;
      for(Grade grade in group.grades){
        groupSum += grade.value;
      }

      var groupAvg = groupSum / group.grades.length;

      sum += groupAvg * (group.part/actual100Percent);
    }

    return sum;
  }

  Map<GradeGroup, double> averageByGroup() {
    Map<GradeGroup, double> mappedAverages = {};

    for (GradeGroup group in groups) {
      mappedAverages[group] = group.average();
    }

    return mappedAverages;
  }

  int gradesNum(){
    var sum = 0;

    for(GradeGroup group in groups){
      sum += group.grades.length;
    }

    return sum;
  }

  Subject({required this.name, required this.groups, required this.createdAt, required this.changedAt});

  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectToJson(this);

  @override
  bool operator ==(Object other) => identical(this, other) || other is Subject && runtimeType == other.runtimeType && name == other.name && groups == other.groups && createdAt == other.createdAt && changedAt == other.changedAt;

  @override
  int get hashCode => name.hashCode ^ groups.hashCode ^ createdAt.hashCode ^ changedAt.hashCode;
}
