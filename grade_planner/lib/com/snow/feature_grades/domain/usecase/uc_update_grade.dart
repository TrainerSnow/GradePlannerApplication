import 'package:grade_planner/com/snow/feature_grades/domain/model/grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_update_subject.dart';

class UpdateGrade {
  SubjectRepository repository;
  UpdateSubject updateSubject;

  UpdateGrade(this.repository, this.updateSubject);

  Future<void> call(Grade grade) async {
    var subjects = await repository.getAllSubjects();

    var subject = subjects.firstWhere((element) => element.name == grade.subjectName);
    subjects.remove(subject);

    var group = subject.groups.firstWhere((element) => element.name == grade.groupName);
    subject.groups.remove(group);

    group.grades.removeAt(group.grades.indexWhere((element) => element.name == grade.name));

    group.grades.add(grade);

    subject.groups.add(group);

    subjects.add(subject);

    updateSubject.call(subject);
  }
}
