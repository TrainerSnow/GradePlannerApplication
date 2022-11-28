import 'package:grade_planner/com/snow/feature_grades/domain/model/userpreferences.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/repository/preferences_repository.dart';

import '../../../di/injecting.dart';

class GetPreferences{
  PreferencesRepository _repository;

  GetPreferences(this._repository);

  Future<UserPreferences> call() async{
    return _repository.getPreferences();
  }
}