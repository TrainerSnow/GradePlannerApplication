import 'package:grade_planner/com/snow/feature_grades/domain/model/gradegroup.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';

import '../model/grade.dart';

const int MONTH = 2629800000;

class GetRecentGrades {
  final SubjectRepository _repository;

  GetRecentGrades(this._repository);

  Future<Iterable<Grade>> call({int millisRange = MONTH}) async {
    var subjects = await _repository.getAllSubjects();

    var groups = <GradeGroup>[];
    for (var subject in subjects) {
      groups.addAll(subject.groups);
    }

    var grades = <Grade>[];
    for (var group in groups) {
      grades.addAll(group.grades);
    }

    var now = DateTime.now().millisecondsSinceEpoch;
    var accepted = now - millisRange;

    return grades.where((element) => element.createdAt > accepted);
  }
}
