import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_add_subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_add_year.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_check_grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_check_subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_check_year.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_delete_grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_delete_subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_all_subjects.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_all_years.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_mean_avg.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_recent_grades.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_recent_subjects.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_subject_by_name.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_subjects_by_goodness.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_is_mark_over_average.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_subject_exists.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_update_grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_update_subject.dart';

class SubjectUsecases {
  final GetAllSubjects getAllSubjects;

  final AddSubject addSubject;

  final DeleteSubject deleteSubject;

  final CheckSubjectInputs checkSubjectInputs;

  final SubjectExists subjectExists;

  final GetSubjectByName getSubjectByName;

  final CheckGradeInputs checkGradeInputs;

  final UpdateSubject updateSubject;

  final CheckYearInput checkYearInput;

  final AddYear addYear;

  final GetAllYears getYears;

  final GetSubjectsByGoodness getSubjectsByGoodness;

  final GetMeanAverage getMeanAverage;

  final GetRecentGrades getRecentGrades;

  final GetRecentSubjects getRecentSubjects;

  final DeleteGrade deleteGrade;

  final IsOverAverage isOverAverage;

  final UpdateGrade updateGrade;

  const SubjectUsecases({
    required this.getAllSubjects,
    required this.addSubject,
    required this.deleteSubject,
    required this.checkSubjectInputs,
    required this.subjectExists,
    required this.getSubjectByName,
    required this.checkGradeInputs,
    required this.updateSubject,
    required this.checkYearInput,
    required this.addYear,
    required this.getYears,
    required this.getSubjectsByGoodness,
    required this.getMeanAverage,
    required this.getRecentGrades,
    required this.getRecentSubjects,
    required this.deleteGrade,
    required this.isOverAverage,
    required this.updateGrade,
  });
}
