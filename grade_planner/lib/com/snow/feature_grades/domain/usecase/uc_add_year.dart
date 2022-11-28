import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';

import '../model/year.dart';

class AddYear{
  SubjectRepository _repository;

  AddYear(this._repository);

  void call(Year year){
    _repository.addYear(year: year);
  }
}