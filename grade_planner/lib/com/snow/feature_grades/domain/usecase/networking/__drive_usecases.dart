import '../local/uc_check_google_signed_in.dart';
import '../uc_request_google_account.dart';

class DriveUsecases {
  RequestGoogleAccount requestGoogleAccount;
  CheckGoogleSignedIn checkGoogleSignedIn;

  DriveUsecases({required this.checkGoogleSignedIn, required this.requestGoogleAccount});
}
