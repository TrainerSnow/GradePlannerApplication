import 'package:grade_planner/com/snow/di/injecting.dart';

import '../model/subject.dart';
import '../repository/subject_repository.dart';
import '../util/subject_creation_responses.dart';

class CheckSubjectInputs{
  final SubjectRepository _repository;

  CheckSubjectInputs(this._repository);

  Future<SubjectCreationResponse> call(String name, List<int> parts, List<String> names) async {
    var subjects = await _repository.getAllSubjects();

    for(Subject s in subjects){
      if(s.name == name){
        return SubjectCreationResponse.SUBJECT_NAME_EXISTS;
      }
    }

    if(name.isEmpty){
      return SubjectCreationResponse.WRONG_NAMES;
    }

    for(int i in parts){
      if(i < 0){
        return SubjectCreationResponse.PARTS_UNFILLED;
      }
    }

    var sum = 0;
    for(int i in parts){
      sum += i;
    }
    if(sum != 100){
      return SubjectCreationResponse.PARTS_DONT_ADD_UP;
    }

    for(String name in names){
      if(name.isEmpty || name.contains(" ")){
        return SubjectCreationResponse.WRONG_NAMES;
      }
    }

    return SubjectCreationResponse.OK;
  }
}