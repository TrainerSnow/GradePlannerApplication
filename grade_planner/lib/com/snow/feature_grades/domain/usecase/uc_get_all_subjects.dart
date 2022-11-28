import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';

import '../model/subject.dart';

class GetAllSubjects implements Function{
  final SubjectRepository _repository;

  const GetAllSubjects(this._repository);

  Future<List<Subject>> call() async {
    return await _repository.getAllSubjects();
  }
}