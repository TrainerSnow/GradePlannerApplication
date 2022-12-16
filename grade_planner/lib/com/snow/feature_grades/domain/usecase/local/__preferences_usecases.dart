import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_preferences.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_update_preferences.dart';

class PreferencesUsecases {
  GetPreferences getPreferences;

  UpdatePreferences updatePreferences;

  PreferencesUsecases({required this.getPreferences, required this.updatePreferences});
}
