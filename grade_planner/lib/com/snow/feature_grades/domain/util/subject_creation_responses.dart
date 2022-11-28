class SubjectCreationResponse {
  String title;

  SubjectCreationResponse._(this.title);

  static final SUBJECT_NAME_EXISTS = SubjectCreationResponse._("Subject name alr exists.");
  static final PARTS_DONT_ADD_UP = SubjectCreationResponse._("The values don't add up to 100.");
  static final WRONG_NAMES = SubjectCreationResponse._("The names are invalid.");
  static final DUPLICATE_NAMES = SubjectCreationResponse._("Only specify each grade group name once.");
  static final PARTS_UNFILLED = SubjectCreationResponse._("Please fill out all part values");

  static final OK = SubjectCreationResponse._("OK");

  bool isOk() => this == OK;
}
