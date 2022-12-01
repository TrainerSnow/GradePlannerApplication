import '../model/subject.dart';
import '../repository/subject_repository.dart';

class GetSubjectByName {
  final SubjectRepository _repository;

  const GetSubjectByName(this._repository);

  Future<Subject> call(String name) async {
    return (await _repository.getAllSubjects()).firstWhere((element) => element.name == name);
  }
}
