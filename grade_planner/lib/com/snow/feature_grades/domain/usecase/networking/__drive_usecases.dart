import '../local/uc_check_google_signed_in.dart';
import '../uc_request_google_account.dart';
import '../uc_request_google_account_silent.dart';
import '../uc_signout_and_request_google_account.dart';
import '../uc_upload_current_to_drive.dart';

class DriveUsecases {
  RequestGoogleAccount requestGoogleAccount;
  CheckGoogleSignedIn checkGoogleSignedIn;
  RequestGoogleAccountSilent requestGoogleAccountSilent;
  SignoutAndRequestGoogleAccount signoutAndRequestGoogleAccount;
  UploadCurrentToDrive uploadCurrentToDrive;

  DriveUsecases({
    required this.checkGoogleSignedIn,
    required this.requestGoogleAccount,
    required this.requestGoogleAccountSilent,
    required this.signoutAndRequestGoogleAccount,
    required this.uploadCurrentToDrive,
  });
}
