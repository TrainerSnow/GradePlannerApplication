import '../model/subject.dart';
import '../model/year.dart';

abstract class SubjectRepository {
  Future<List<Subject>> getAllSubjects();

  Future<List<Year>> getAllYears();

  Future<void> addSubject({required Subject subject});

  Future<void> addSubjectWithYear({required Subject subject, required Year year});

  Future<void> addYear({required Year year});

  Future<void> removeSubject({required Subject subject});

  Future<void> updateSubject({required Subject subject});
}
