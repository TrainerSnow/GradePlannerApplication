import 'package:grade_planner/com/snow/feature_grades/domain/model/year.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';

class GetAllYears {
  SubjectRepository _repository;

  GetAllYears(this._repository);

  Future<List<Year>> call() {
    return _repository.getAllYears();
  }
}
