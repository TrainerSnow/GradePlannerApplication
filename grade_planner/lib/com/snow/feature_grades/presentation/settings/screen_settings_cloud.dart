import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/networking/__drive_usecases.dart';

import '../../../../../main.dart';

class ScreenSettingsDrive extends StatefulWidget {
  final String title;

  const ScreenSettingsDrive({Key? key, required this.title}) : super(key: key);

  @override
  State<ScreenSettingsDrive> createState() => _ScreenSettingsDriveState();
}

//TODO: translate
class _ScreenSettingsDriveState extends State<ScreenSettingsDrive> {
  late DriveUsecases driveUsecases;
  late Future<GoogleSignInAccount?> account;

  void _signInSilent() async {
    FLog.info(text: "Trying to silently sign in to Google");
    account = driveUsecases.requestGoogleAccountSilent();
    account.then((value) {
      FLog.info(text: "SIGN IN SILENT: Account completed with $value");
    });
  }

  void _clickSignInGoogle() async {
    FLog.info(text: "User clicked on sign in with Google");
    setState(() {
      account = driveUsecases.signoutAndRequestGoogleAccount();
      account.then((value) {
        FLog.info(text: "SIGN IN: Account completed with $value");
      }).onError((error, stackTrace) {
        FLog.info(
            text:
                "SIGN IN: Account getting did not complete.\nError: $error\nStacktrace:\n${stackTrace.toString()}");
      });
    });
  }

  void _uploadToGoogleDrive() async {
    FLog.info(text: "User clicked on upload data to Google Drive");
    final user = await driveUsecases.requestGoogleAccountSilent();
    FLog.info(text: "Will use user $user for Google Drive OP");

    if (user != null) {
      final result = driveUsecases.uploadCurrentToDrive(account: user);
      result.then((value) async {
        FLog.info(
            text: "Google drive upload was succesful, got result:\n$value");
      }).onError((error, stackTrace) async {
        FLog.info(
            text:
                "Google drive upload failed.\nError: $error\nStacktrace: ${stackTrace.toString()}");
      });
    }
  }

  @override
  void initState() {
    driveUsecases = provider.get<DriveUsecases>();
    _signInSilent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SettingsGroup(
            title: AppLocalizations.of(context)!.google_drive,
            children: [
              FutureBuilder<GoogleSignInAccount?>(
                future: account,
                builder: (context, shot) {
                  if ((shot.hasData && shot.data == null) || !shot.hasData) {
                    return SimpleSettingsTile(
                      title:
                          AppLocalizations.of(context)!.connect_google_account,
                      onTap: _clickSignInGoogle,
                    );
                  } else {
                    return SimpleSettingsTile(
                      title:
                          AppLocalizations.of(context)!.connect_google_account,
                      onTap: _clickSignInGoogle,
                      subtitle:
                          "${shot.data!.displayName} : ${shot.data!.email}",
                    );
                  }
                },
              ),
              SimpleSettingsTile(
                title: AppLocalizations.of(context)!.upload_current_to_drive,
                onTap: _uploadToGoogleDrive,
              )
            ],
          ),
        ],
      ),
    );
  }
}
