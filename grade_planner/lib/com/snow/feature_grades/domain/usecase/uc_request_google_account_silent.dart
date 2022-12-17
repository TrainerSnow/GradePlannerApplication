import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class RequestGoogleAccountSilent {
  const RequestGoogleAccountSilent();

  Future<GoogleSignInAccount?> call() async {
    final googleSignIn = GoogleSignIn.standard(scopes: [DriveApi.driveScope]);
    final GoogleSignInAccount? account = await googleSignIn.signInSilently();
    return account;
  }
}
