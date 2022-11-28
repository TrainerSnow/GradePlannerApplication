import 'package:grade_planner/com/snow/feature_grades/domain/model/subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';

const int MONTH = 2629800000;

class GetRecentSubjects{
  final SubjectRepository _repository;

  GetRecentSubjects(this._repository);

  Future<Iterable<Subject>> call({int millisRange = MONTH})async{
    var subjects = await _repository.getAllSubjects();

    var now = DateTime.now().millisecondsSinceEpoch;
    var accepted = now - millisRange;

    return subjects.where((element) => element.changedAt > accepted);
  }
}