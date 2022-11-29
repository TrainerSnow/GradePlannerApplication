class YearCreationResponse {
  final String title;

  const YearCreationResponse._(this.title);

  static const YEAR_NAME_EXISTS = YearCreationResponse._("Year name alr exists.");
  static const YEAR_NAME_INVALID = YearCreationResponse._("Year name is invalid");

  static final OK = YearCreationResponse._("OK");

  bool isOk() => this == OK;
}
