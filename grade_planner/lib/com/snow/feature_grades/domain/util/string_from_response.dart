import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/util/subject_creation_responses.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/util/year_creation_response.dart';

import 'grade_creation_response.dart';

class StringFromResponse {
  static String get(BuildContext context, Object response) {
    var local = AppLocalizations.of(context)!;

    switch (response) {
      case YearCreationResponse.YEAR_NAME_INVALID:
        return local.year_name_invalid;
      case YearCreationResponse.YEAR_NAME_EXISTS:
        return local.year_name_exists;
      case GradeCreationResponse.SUBJECT_NOT_FOUND:
        return local.subject_not_found;
      case GradeCreationResponse.GROUP_NOT_FOUND:
        return local.group_not_found;
      case GradeCreationResponse.GRADE_NAME_INVALID:
        return local.grade_name_invalid;
      case GradeCreationResponse.GRADE_NAME_EXISTS:
        return local.grade_name_exists;
      case GradeCreationResponse.GRADE_VALUE_INVALID:
        return local.grade_value_invalid;
      case SubjectCreationResponse.SUBJECT_NAME_EXISTS:
        return local.subject_name_exists;
      case SubjectCreationResponse.PARTS_DONT_ADD_UP:
        return local.parts_not_add_up;
      case SubjectCreationResponse.WRONG_NAMES:
        return local.names_invalid;
      case SubjectCreationResponse.DUPLICATE_NAMES:
        return local.duplicate_names;
      case SubjectCreationResponse.PARTS_UNFILLED:
        return local.parts_unfilled;
      default:
        throw Error();
    }
  }
}
