import 'package:grade_planner/com/snow/feature_grades/domain/model/grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_mean_avg.dart';

import '../../../di/injecting.dart';

class IsOverAverage{

  final GetMeanAverage _getMeanAverage;

  IsOverAverage(this._getMeanAverage);

  Future<bool> callGrade(Grade grade, int orderMode) async{
    var meanAvg = await _getMeanAverage.call();
    var result = orderMode == 1 ?
        grade.value <= meanAvg :
        grade.value >= meanAvg;

    return result;
  }

  Future<bool> callSubject(Subject grade, int orderMode) async{
    return orderMode == 1 ?
        grade.average() <= await _getMeanAverage.call() :
        grade.average() >= await _getMeanAverage.call();
  }
}