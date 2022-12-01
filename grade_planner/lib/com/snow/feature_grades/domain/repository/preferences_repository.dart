import '../model/userpreferences.dart';

abstract class PreferencesRepository {
  Future<UserPreferences> getPreferences();

  void updatePreferences(UserPreferences preferences);
}
