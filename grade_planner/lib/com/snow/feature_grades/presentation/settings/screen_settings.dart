import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/networking/__drive_usecases.dart';
import 'package:grade_planner/com/snow/feature_grades/presentation/settings/settings_about_screen.dart';
import 'package:grade_planner/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  final String title;

  const SettingsScreen({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late DriveUsecases driveUsecases;

  late Future<PackageInfo> packageInfo;
  late Future<GoogleSignInAccount?> accountInfo;

  late int orderMode;

  void _clickChangeOrderingMode(int value) async {
    Settings.setValue("order_mode", value);
    setState(() {
      orderMode = Settings.getValue("order_mode", defaultValue: 1)!;
    });
  }

  void _clickOpenAbout() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsABoutScreen(title: "About")));
  }

  @override
  void initState() {
    packageInfo = PackageInfo.fromPlatform();

    driveUsecases = provider.get<DriveUsecases>();
    setState(() {
      orderMode = Settings.getValue("order_mode", defaultValue: 1)!;
    });
    _signInSilent();
  }

  void _clickSignInGoogle() async {
    FLog.info(text: "User clicked on sign in with Google");
    setState(() {
      accountInfo = driveUsecases.signoutAndRequestGoogleAccount();
      accountInfo.then((value) {
        FLog.info(text: "SIGN IN: Account completed with $value");
      });
    });
  }

  void _signInSilent() async {
    FLog.info(text: "Trying to silently sign in to Google");
    accountInfo = driveUsecases.requestGoogleAccountSilent();
    accountInfo.then((value) {
      FLog.info(text: "SIGN IN SILENT: Account completed with $value");
    });
  }

  void _uploadToGoogleDrive() async {
    FLog.info(text: "User clicked on upload data to Google Drive");
    final user = await driveUsecases.requestGoogleAccountSilent();
    FLog.info(text: "Will use user $user for Google Drive OP");

    if (user != null) {
      final result = driveUsecases.uploadCurrentToDrive(account: user);
      result.then((value) async {}).onError((error, stackTrace) async {});
    }
  }

  void _uploadToGoogleDriveLogs(File file) async {
    final user = await driveUsecases.requestGoogleAccountSilent();

    if (user != null) {
      driveUsecases.uploadCurrentToDrive(account: user, file: file);
    }
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
            title: AppLocalizations.of(context)!.grades,
            children: [
              DropDownSettingsTile(
                title: AppLocalizations.of(context)!.grade_ordering,
                settingKey: "grade_ordering",
                selected: orderMode,
                values: <int, String>{1: AppLocalizations.of(context)!.order_low_good, 2: AppLocalizations.of(context)!.order_low_bad},
                onChange: _clickChangeOrderingMode,
              ),
            ],
          ),
          SettingsGroup(
            title: AppLocalizations.of(context)!.cloud_storage,
            children: [
              FutureBuilder<GoogleSignInAccount?>(
                future: accountInfo,
                builder: (context, shot) {
                  if ((shot.hasData && shot.data == null) || !shot.hasData) {
                    return SimpleSettingsTile(
                      title: "Mit Google Konto verknüfen",
                      onTap: _clickSignInGoogle,
                    );
                  } else {
                    return SimpleSettingsTile(
                      title: "Mit Google Konto verknüfen",
                      onTap: _clickSignInGoogle,
                      subtitle: "${shot.data!.displayName} : ${shot.data!.email}",
                    );
                  }
                },
              ),
              //TODO: translate
              SimpleSettingsTile(
                title: "Upload current Data to google drive",
                onTap: _uploadToGoogleDrive,
              )
            ],
          ),
          SettingsGroup(
            title: AppLocalizations.of(context)!.misc,
            children: [
              SimpleSettingsTile(
                title: AppLocalizations.of(context)!.about_this_app,
                onTap: _clickOpenAbout,
              ),
            ],
          ),
          SettingsGroup(
            title: "Debug",
            children: [
              SimpleSettingsTile(
                title: "Upload logs to Drive",
                onTap: () async {
                  _uploadToGoogleDriveLogs(await FLog.exportLogs());
                },
              ),
              SimpleSettingsTile(
                title: "Clear Logs",
                onTap: () async {
                  FLog.clearLogs();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
