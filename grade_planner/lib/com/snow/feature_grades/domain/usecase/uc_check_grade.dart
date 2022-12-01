import 'package:grade_planner/com/snow/feature_grades/domain/model/gradegroup.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/util/grade_creation_response.dart';

import '../model/subject.dart';
import '../repository/subject_repository.dart';

class CheckGradeInputs {
  final SubjectRepository _repository;

  CheckGradeInputs(this._repository);

  Future<GradeCreationResponse> call(String name, double value, Subject? subject, GradeGroup? group) async {
    if (subject == null) {
      return GradeCreationResponse.SUBJECT_NOT_FOUND;
    }

    if (group == null) {
      return GradeCreationResponse.GROUP_NOT_FOUND;
    }

    if (!subject.groups.map((e) => e.name).contains(group.name)) {
      return GradeCreationResponse.GROUP_NOT_FOUND;
    }

    if (name.isEmpty) {
      return GradeCreationResponse.GRADE_NAME_INVALID;
    }

    if (subject.groups.firstWhere((element) => element.name == group.name).grades.any((element) => element.name == name)) {
      return GradeCreationResponse.GRADE_NAME_EXISTS;
    }

    if (value < 0) {
      return GradeCreationResponse.GRADE_VALUE_INVALID;
    }

    return GradeCreationResponse.OK;
  }
}
