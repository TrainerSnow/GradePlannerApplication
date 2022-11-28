import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/util/year_creation_response.dart';

import '../model/year.dart';

class CheckYearInput{
  final SubjectRepository _subjectRepository;

  CheckYearInput(this._subjectRepository);

  Future<YearCreationResponse> call(Year year) async{
    var years = await _subjectRepository.getAllYears();

    if(years.map((e) => e.name).contains(year.name)){
      return YearCreationResponse.YEAR_NAME_EXISTS;
    }

    if(year.name.isEmpty){
      return YearCreationResponse.YEAR_NAME_INVALID;
    }

    return YearCreationResponse.OK;
  }
}