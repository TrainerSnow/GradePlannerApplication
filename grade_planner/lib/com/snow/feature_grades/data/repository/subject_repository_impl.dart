import 'dart:convert';

import 'package:grade_planner/com/snow/di/injecting.dart';
import 'package:grade_planner/com/snow/feature_grades/data/source/subject_database.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/year.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/repository/preferences_repository.dart';


class SubjectRepositoryImpl extends SubjectRepository {
  SubjectDatabase database;
  PreferencesRepository pref_repo;

  SubjectRepositoryImpl(this.database, this.pref_repo);

  @override
  Future<void> addSubject({required Subject subject}) async {
    var currentYearName = (await pref_repo.getPreferences()).currentYear;
    //All years
    List<Year> years = await getAllYears();

    var currentYear = years.firstWhere((element) => element.name == currentYearName);
    years.remove(currentYear);

    currentYear.subjects.add(subject);

    years.add(currentYear);

    String jsonList = jsonEncode(years);

    return database.replaceRawData(content: jsonList);
  }

  @override
  Future<List<Subject>> getAllSubjects() async {
    List<Year> years = await getAllYears();


    var currentName = (await pref_repo.getPreferences()).currentYear;
    var currentYear = years.firstWhere((element) => element.name == currentName);

    return currentYear.subjects;
  }

  @override
  Future<void> removeSubject({required Subject subject}) async {
    var currentYearName = (await pref_repo.getPreferences()).currentYear;
    //All years
    List<Year> years = await getAllYears();

    var currentYear = years.firstWhere((element) => element.name == currentYearName);
    years.remove(currentYear);

    for(int i = 0; i < currentYear.subjects.length; i++){
      if(currentYear.subjects[i].name == subject.name){
        currentYear.subjects.removeAt(i);
        break;
      }
    }


    years.add(currentYear);

    String jsonList = jsonEncode(years);

    return database.replaceRawData(content: jsonList);
  }

  @override
  Future<void> updateSubject({required Subject subject}) async {
    List<Subject> subjects = await getAllSubjects();

    if (subjects.map((e) => e.name).contains(subject.name)) {
      var currentYearName = (await pref_repo.getPreferences()).currentYear;
      //All years
      List<Year> years = await getAllYears();

      var currentYear = years.firstWhere((element) => element.name == currentYearName);
      years.remove(currentYear);

      currentYear.subjects.removeWhere((element) => element.name == subject.name);

      subject.changedAt = DateTime.now().millisecondsSinceEpoch;
      currentYear.subjects.add(subject);

      years.add(currentYear);

      String jsonList = jsonEncode(years);

      return database.replaceRawData(content: jsonList);
    } else {
      throw ArgumentError("There is currenlty no subject with name '${subject.name}'.");
    }
  }

  @override
  void addYear({required Year year}) async{
    List<Year> years = await getAllYears();
    years.add(year);

    String jsonList = jsonEncode(years);

    database.replaceRawData(content: jsonList);
  }

  @override
  Future<List<Year>> getAllYears() async{
    String content = await database.getRawGradeData();
    log.i("Got db content: $content");
    final List<dynamic> jsonList = jsonDecode(content);

    List<Year> years = jsonList.map((e) => Year.fromJson(e)).toList();

    return years;
  }
}
