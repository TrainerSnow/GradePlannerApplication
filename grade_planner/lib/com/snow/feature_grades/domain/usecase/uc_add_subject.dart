import '../model/subject.dart';
import '../model/year.dart';
import '../repository/subject_repository.dart';

class AddSubject {
  final SubjectRepository _repository;

  const AddSubject(this._repository);

  Future<void> call(Subject subject) async {
    return _repository.addSubject(subject: subject);
  }

  Future<void> callWithYear(Subject subject, Year year) async {
    return _repository.addSubjectWithYear(subject: subject, year: year);
  }
}
