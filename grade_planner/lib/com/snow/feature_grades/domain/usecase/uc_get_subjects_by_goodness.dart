import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';

import '../model/subject.dart';

class GetSubjectsByGoodness {
  SubjectRepository _repository;

  GetSubjectsByGoodness(this._repository);

  Future<List<Subject>> call() async {
    var subjects = await _repository.getAllSubjects();

    subjects.sort((Subject a, Subject b) {
      return a.average().compareTo(b.average());
    });

    return subjects;
  }
}
