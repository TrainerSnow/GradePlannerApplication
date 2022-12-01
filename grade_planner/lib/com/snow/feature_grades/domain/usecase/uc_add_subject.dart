import '../model/subject.dart';
import '../repository/subject_repository.dart';

class AddSubject {
  final SubjectRepository _repository;

  const AddSubject(this._repository);

  Future<void> call(Subject subject) async {
    return _repository.addSubject(subject: subject);
  }
}
