import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';

import '../model/subject.dart';

class UpdateSubject{

  SubjectRepository _repository;

  UpdateSubject(this._repository);

  Future<void> call(Subject subject){
    return _repository.updateSubject(subject: subject);
  }

}