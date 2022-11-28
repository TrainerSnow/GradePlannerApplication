class GradeCreationResponse {
  String title;

  GradeCreationResponse._(this.title);

  static final SUBJECT_NOT_FOUND = GradeCreationResponse._("Subject with that name was not found.");
  static final GROUP_NOT_FOUND = GradeCreationResponse._("Group was not found in that subject.");
  static final GRADE_NAME_INVALID = GradeCreationResponse._("The grade name is invalid.");
  static final GRADE_NAME_EXISTS = GradeCreationResponse._("The grade name already exists in this group");
  static final GRADE_VALUE_INVALID = GradeCreationResponse._("The grade value is invalid");


  static final OK = GradeCreationResponse._("OK");

  bool isOk() => this == OK;
}
