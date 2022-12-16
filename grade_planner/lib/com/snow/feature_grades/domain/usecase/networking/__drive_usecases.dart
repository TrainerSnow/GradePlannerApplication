import '../local/uc_check_google_signed_in.dart';
import '../uc_request_google_account.dart';
import '../uc_request_google_account_silent.dart';
import '../uc_signout_and_request_google_account.dart';

class DriveUsecases {
  RequestGoogleAccount requestGoogleAccount;
  CheckGoogleSignedIn checkGoogleSignedIn;
  RequestGoogleAccountSilent requestGoogleAccountSilent;
  SignoutAndRequestGoogleAccount signoutAndRequestGoogleAccount;

  DriveUsecases({required this.checkGoogleSignedIn, required this.requestGoogleAccount, required this.requestGoogleAccountSilent, required this.signoutAndRequestGoogleAccount});
}
