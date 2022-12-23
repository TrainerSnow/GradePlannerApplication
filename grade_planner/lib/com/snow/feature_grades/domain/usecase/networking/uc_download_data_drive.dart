import 'dart:convert';
import 'dart:io' as io;

import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as commons;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as google;

import '../../../data/networking/GoogleAuthClient.dart';

const FILE_NAME = "grade_data_%s_%s_%s_.json";

class DownloadFromDrive {
  final io.File subjectFile;

  DownloadFromDrive(this.subjectFile);

  Future<void> call({required GoogleSignInAccount account}) async {
    final data = await _downloadFile(
      (name) {
        return name.startsWith("grade_data_") && name.endsWith("_.json");
      },
      account,
    );
    await subjectFile.writeAsString(data);
  }

  Future<String> _downloadFile(
      bool Function(String) isFile, GoogleSignInAccount account) async {
    final headers = await account.authHeaders;
    final authClient = GoogleAuthClient(headers);
    final driveApi = google.DriveApi(authClient);

    final fileList = await driveApi.files.list();
    if (fileList.files != null) {
      for (google.File file in fileList.files!) {
        if (file.name != null) {
          if (isFile(file.name!)) {
            if (file.id != null) {
              final media = await driveApi.files.get(file.id!,
                  downloadOptions: commons.DownloadOptions.fullMedia);
              if (media is google.Media) {
                final data = (await media.stream.first);
                return utf8.decode(data);
              }
            }
          }
        }
      }
    }
    return Future.error("An error occured");
  }
}
