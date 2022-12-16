import '../local/uc_check_google_signed_in.dart';
import '../uc_request_google_account.dart';
import '../uc_request_google_account_silent.dart';

class DriveUsecases {
  RequestGoogleAccount requestGoogleAccount;
  CheckGoogleSignedIn checkGoogleSignedIn;
  RequestGoogleAccountSilent requestGoogleAccountSilent;

  DriveUsecases({required this.checkGoogleSignedIn, required this.requestGoogleAccount, required this.requestGoogleAccountSilent});
}
