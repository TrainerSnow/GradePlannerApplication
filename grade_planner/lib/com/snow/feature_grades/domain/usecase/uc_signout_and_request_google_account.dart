import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class SignoutAndRequestGoogleAccount {
  const SignoutAndRequestGoogleAccount();

  Future<GoogleSignInAccount?> call() async {
    final googleSignIn = GoogleSignIn.standard(scopes: [DriveApi.driveScope]);
    googleSignIn.signOut();
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    return account;
  }
}
