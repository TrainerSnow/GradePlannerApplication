class YearCreationResponse {
  String title;

  YearCreationResponse._(this.title);

  static final YEAR_NAME_EXISTS = YearCreationResponse._("Year name alr exists.");
  static final YEAR_NAME_INVALID = YearCreationResponse._("Year name is invalid");

  static final OK = YearCreationResponse._("OK");

  bool isOk() => this == OK;
}
