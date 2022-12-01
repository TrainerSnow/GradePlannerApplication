class SubjectCreationResponse {
  final String title;

  const SubjectCreationResponse._(this.title);

  static const SUBJECT_NAME_EXISTS = SubjectCreationResponse._("Subject name alr exists.");
  static const PARTS_DONT_ADD_UP = SubjectCreationResponse._("The values don't add up to 100.");
  static const WRONG_NAMES = SubjectCreationResponse._("The names are invalid.");
  static const DUPLICATE_NAMES = SubjectCreationResponse._("Only specify each grade group name once.");
  static const PARTS_UNFILLED = SubjectCreationResponse._("Please fill out all part values");

  static final OK = SubjectCreationResponse._("OK");

  bool isOk() => this == OK;
}
