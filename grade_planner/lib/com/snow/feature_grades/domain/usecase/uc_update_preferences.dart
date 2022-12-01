import 'package:grade_planner/com/snow/feature_grades/domain/model/userpreferences.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/repository/preferences_repository.dart';

class UpdatePreferences {
  PreferencesRepository _repository;

  UpdatePreferences(this._repository);

  void call(UserPreferences preferences) {
    _repository.updatePreferences(preferences);
  }
}
