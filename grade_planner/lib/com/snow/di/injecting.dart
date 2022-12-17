import 'dart:io';

import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:grade_planner/com/snow/feature_grades/data/repository/images_repository_impl.dart';
import 'package:grade_planner/com/snow/feature_grades/data/repository/preference_repository_impl.dart';
import 'package:grade_planner/com/snow/feature_grades/data/repository/subject_repository_impl.dart';
import 'package:grade_planner/com/snow/feature_grades/data/source/images_database.dart';
import 'package:grade_planner/com/snow/feature_grades/data/source/preferences_database.dart';
import 'package:grade_planner/com/snow/feature_grades/data/source/subject_database.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/local/__images_usecases.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/local/__preferences_usecases.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/local/__subject_usecases.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_add_image.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_add_subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_add_year.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_check_grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_check_subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_check_year.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_clear_cache.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_delete_grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_delete_subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_all_images.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_all_subjects.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_all_years.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_images_for_subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_preferences.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_recent_subjects.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_subject_by_name.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_subjects_by_goodness.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_is_mark_over_average.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_subject_exists.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_update_grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_update_preferences.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_update_subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_upload_current_to_drive.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../common/util/log_output.dart';
import '../feature_grades/domain/repository/subject_repository.dart';
import '../feature_grades/domain/usecase/local/uc_check_google_signed_in.dart';
import '../feature_grades/domain/usecase/networking/__drive_usecases.dart';
import '../feature_grades/domain/usecase/uc_delete_image_by_grade.dart';
import '../feature_grades/domain/usecase/uc_get_mean_avg.dart';
import '../feature_grades/domain/usecase/uc_get_recent_grades.dart';
import '../feature_grades/domain/usecase/uc_request_google_account.dart';
import '../feature_grades/domain/usecase/uc_request_google_account_silent.dart';
import '../feature_grades/domain/usecase/uc_signout_and_request_google_account.dart';

late Logger log;

class ModuleContainer {
  Future<Injector> init(Injector injector) async {
    final loggerFile = File(await _logFile());

    log = Logger(output: FileOutput(loggerFile));

    final subjectFile = File(await _subjectFile());
    final preferencesFile = File(await _preferencesFile());
    final imagesDir = Directory(await _imagesDir());

    var subjectDatabase = SubjectDatabase(subjectFile);
    injector.map<SubjectDatabase>((injector) => subjectDatabase);

    var preferencesDatabase = PreferencesDatabase(preferencesFile);
    injector.map<PreferencesDatabase>((injector) => preferencesDatabase);

    var imagesDatabase = ImagesDatabase(imagesDir);
    injector.map<ImagesDatabase>((injector) => imagesDatabase);

    var preferences_repo = PreferencesRepositoryImpl(preferencesDatabase);
    injector.map<PreferencesRepositoryImpl>((injector) => preferences_repo);

    var subject_repo = SubjectRepositoryImpl(subjectDatabase, preferences_repo);
    injector.map<SubjectRepository>((injector) => subject_repo);

    var images_repo = ImagesRepositoryImpl(imagesDatabase);
    injector.map<ImagesRepositoryImpl>((injector) => images_repo);

    /*

     */
    var getPreferences = GetPreferences(preferences_repo);

    var getAllImages = GetAllImages(images_repo);
    var getImagesByGrade = GetImagesForGrade(getAllImages, getPreferences);

    var getAllSubjects = GetAllSubjects(subject_repo);
    var addSubject = AddSubject(subject_repo);
    var deleteSubject = DeleteSubject(subject_repo, getImagesByGrade);
    var checkSubjectsInputs = CheckSubjectInputs(subject_repo);
    var subjectExists = SubjectExists(subject_repo);
    var getSubjectByName = GetSubjectByName(subject_repo);
    var checkGradeInputs = CheckGradeInputs(subject_repo);
    var updateSubject = UpdateSubject(subject_repo);
    var checkYearsInput = CheckYearInput(subject_repo);
    var addYear = AddYear(subject_repo);
    var getYears = GetAllYears(subject_repo);
    var getSubjectsByGoodness = GetSubjectsByGoodness(subject_repo);
    var getMeanAverage = GetMeanAverage(subject_repo);
    var getRecentSubjects = GetRecentSubjects(subject_repo);
    var getRecentGrades = GetRecentGrades(subject_repo);
    var deleteGrade = DeleteGrade(subject_repo, getImagesByGrade);
    var isOverAverage = IsOverAverage(getMeanAverage);
    var updateGrade = UpdateGrade(subject_repo, updateSubject);

    injector.map<SubjectUsecases>((injector) => SubjectUsecases(
      getAllSubjects: getAllSubjects,
      addSubject: addSubject,
      deleteSubject: deleteSubject,
      checkSubjectInputs: checkSubjectsInputs,
      subjectExists: subjectExists,
      getSubjectByName: getSubjectByName,
      checkGradeInputs: checkGradeInputs,
      updateSubject: updateSubject,
      checkYearInput: checkYearsInput,
      addYear: addYear,
      getYears: getYears,
      getSubjectsByGoodness: getSubjectsByGoodness,
      getMeanAverage: getMeanAverage,
      getRecentGrades: getRecentGrades,
      getRecentSubjects: getRecentSubjects,
      deleteGrade: deleteGrade,
      isOverAverage: isOverAverage,
      updateGrade: updateGrade,
    ));

    var updatePreferences = UpdatePreferences(preferences_repo);

    injector.map<PreferencesUsecases>((injector) => PreferencesUsecases(getPreferences: getPreferences, updatePreferences: updatePreferences));

    var addImage = AddImage(images_repo);
    var deleteCache = DeleteCache(images_repo);

    var deleteImageByGrade = DeleteImageByGrade(getImagesByGrade, getPreferences);

    injector.map<ImagesUsecases>(
          (injector) => ImagesUsecases(
        addImage: addImage,
        deleteCache: deleteCache,
        getAllImages: getAllImages,
        getImagesForGrade: getImagesByGrade,
        deleteImageByGrade: deleteImageByGrade,
      ),
    );

    var requestGoogleAccount = const RequestGoogleAccount();
    var requestGoogleAccountSilent = const RequestGoogleAccountSilent();
    var checkGoogleSignedIn = const CheckGoogleSignedIn();
    var signoutAndRequestGoogleAccount = const SignoutAndRequestGoogleAccount();
    var uploadCurrentToDrive = UploadCurrentToDrive(subjectFile);

    injector.map<DriveUsecases>((injector) => DriveUsecases(
      requestGoogleAccount: requestGoogleAccount,
      checkGoogleSignedIn: checkGoogleSignedIn,
      requestGoogleAccountSilent: requestGoogleAccountSilent,
      signoutAndRequestGoogleAccount: signoutAndRequestGoogleAccount,
      uploadCurrentToDrive: uploadCurrentToDrive,
    ));

    return Future.value(injector);
  }
}

Future<String> _subjectFile() async {
  var dir = await getApplicationDocumentsDirectory();
  var file = File("${dir.path}/subject_data.json");
  if (!file.existsSync()) {
    file.create();
  }
  return Future.value(file.path);
}

Future<String> _logFile() async {
  var dir = await getApplicationDocumentsDirectory();
  var file = File("${dir.path}/log.txt");
  if (!file.existsSync()) {
    file.create();
  }
  return Future.value(file.path);
}

Future<String> _preferencesFile() async {
  var dir = await getApplicationDocumentsDirectory();
  var file = File("${dir.path}/preferences.json");
  if (!file.existsSync()) {
    file.create();
  }
  return Future.value(file.path);
}

Future<String> _imagesDir() async {
  var dir = await getApplicationDocumentsDirectory();
  var imagesDir = Directory("${dir.path}/photos");
  if (!imagesDir.existsSync()) {
    imagesDir.create();
  }
  return Future.value(imagesDir.path);
}
