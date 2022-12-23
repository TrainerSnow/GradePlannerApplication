import 'dart:io' as io;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as google;
import 'package:sprintf/sprintf.dart';

import '../../../data/networking/GoogleAuthClient.dart';

const FILE_NAME = "grade_data_%s_%s_%s_.json";
const LOGS_FILENAME = "logs.txt";

class UploadCurrentToDrive {
  io.File currentFile;

  UploadCurrentToDrive(this.currentFile);

  Future<google.File> call({required GoogleSignInAccount account, io.File? file}) async {
    if (file == null) {
      return _uploadFile(
        account,
        currentFile,
        sprintf(FILE_NAME, [
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ]),
        (api) => _deleteOtherGradeFiles(api),
      );
    } else {
      return _uploadFile(
        account,
        file,
        LOGS_FILENAME,
        (api) => _deleteOtherLogFiles(api),
      );
    }
  }

  Future<google.File> _uploadFile(GoogleSignInAccount account, io.File file, String targetName, Function(google.DriveApi) onDelete) async {
    final headers = await account.authHeaders;
    final authClient = GoogleAuthClient(headers);
    final driveApi = google.DriveApi(authClient);

    onDelete(driveApi);

    final Stream<List<int>> mediaStream = file.openRead();
    final list = await mediaStream.first;

    final media = google.Media(Future.value(list).asStream().asBroadcastStream(), list.length);

    final driveFile = google.File();
    driveFile.name = targetName;
    return driveApi.files.create(driveFile, uploadMedia: media);
  }

  void _deleteFilesWithCondition(bool Function(String) check, google.DriveApi driveApi) async {
    final files = await driveApi.files.list();

    if (files.files != null) {
      for (google.File file in files.files!) {
        if (file.name != null) {
          if (check(file.name!)) {
            if (file.id != null) {
              driveApi.files.delete(file.id!);
            }
          }
        }
      }
    }
  }

  void _deleteOtherLogFiles(google.DriveApi driveApi) async {
    _deleteFilesWithCondition((name) => name == "logs.txt", driveApi);
  }

  void _deleteOtherGradeFiles(google.DriveApi driveApi) async {
    _deleteFilesWithCondition((name) => name.startsWith("grade_data") && name.endsWith(".json"), driveApi);
  }
}
