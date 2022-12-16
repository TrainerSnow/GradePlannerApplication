import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class CheckGoogleSignedIn {
  const CheckGoogleSignedIn();

  Future<bool> call() async {
    return GoogleSignIn.standard(scopes: [DriveApi.driveScope]).isSignedIn();
  }
}
