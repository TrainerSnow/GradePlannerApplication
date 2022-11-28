import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';

class SubjectExists{
  final SubjectRepository _repository;

  const SubjectExists(this._repository);

  Future<bool> call (String name) async {
    return ( await _repository.getAllSubjects()).map((e) => e.name).contains(name);
  }
}