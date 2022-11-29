class GradeCreationResponse {
  final String title;

  const GradeCreationResponse._(this.title);

  static const SUBJECT_NOT_FOUND = GradeCreationResponse._("Subject with that name was not found.");
  static const GROUP_NOT_FOUND = GradeCreationResponse._("Group was not found in that subject.");
  static const GRADE_NAME_INVALID = GradeCreationResponse._("The grade name is invalid.");
  static const GRADE_NAME_EXISTS = GradeCreationResponse._("The grade name already exists in this group");
  static const GRADE_VALUE_INVALID = GradeCreationResponse._("The grade value is invalid");


  static final OK = GradeCreationResponse._("OK");

  bool isOk() => this == OK;
}
