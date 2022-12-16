import 'dart:io' as io;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as google;
import 'package:sprintf/sprintf.dart';

import '../../data/networking/GoogleAuthClient.dart';

const FILE_NAME = "grade_data_%s_%s_%s_.json";

class UploadCurrentToDrive {
  io.File currentFile;

  UploadCurrentToDrive(this.currentFile);

  Future<google.File> call(GoogleSignInAccount account) async {
    final headers = await account.authHeaders;
    final authClient = GoogleAuthClient(headers);
    final driveApi = google.DriveApi(authClient);

    _deleteOtherGradeFiles(driveApi);

    final Stream<List<int>> mediaStream = currentFile.openRead();
    final list = await mediaStream.first;

    final media = google.Media(Future.value(list).asStream().asBroadcastStream(), list.length);

    final driveFile = google.File();
    driveFile.name = sprintf(FILE_NAME, [
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ]);
    return driveApi.files.create(driveFile, uploadMedia: media);
  }

  void _deleteOtherGradeFiles(google.DriveApi driveApi) async {
    final files = await driveApi.files.list();

    if (files.files != null) {
      for (google.File file in files.files!) {
        if (file.name != null) {
          if (file.name!.startsWith("grade_data") && file.name!.endsWith(".json")) {
            if (file.id != null) {
              driveApi.files.delete(file.id!);
            }
          }
        }
      }
    }
  }
}
