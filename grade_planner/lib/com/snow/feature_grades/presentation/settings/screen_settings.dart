import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/networking/__drive_usecases.dart';
import 'package:grade_planner/com/snow/feature_grades/presentation/settings/screen_settings_cloud.dart';
import 'package:grade_planner/com/snow/feature_grades/presentation/settings/settings_about_screen.dart';
import 'package:grade_planner/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../viewLogs/screen_view_logs.dart';

class SettingsScreen extends StatefulWidget {
  final String title;

  const SettingsScreen({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late DriveUsecases driveUsecases;

  late Future<PackageInfo> packageInfo;

  late int orderMode;

  void _clickChangeOrderingMode(int value) async {
    Settings.setValue("order_mode", value);
    setState(() {
      orderMode = Settings.getValue("order_mode", defaultValue: 1)!;
    });
  }

  void _clickOpenAbout() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            SettingsABoutScreen(title: AppLocalizations.of(context)!.about)));
  }

  void _clickOpenCloud() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ScreenSettingsDrive(title: AppLocalizations.of(context)!.about)));
  }

  void _clickViewLogs() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ScreenViewLogs(title: AppLocalizations.of(context)!.show_logs)));
  }

  @override
  void initState() {
    super.initState();
    packageInfo = PackageInfo.fromPlatform();

    driveUsecases = provider.get<DriveUsecases>();
    setState(() {
      orderMode = Settings.getValue("order_mode", defaultValue: 1)!;
    });
    _signInSilent();
  }

  void _signInSilent() async {
    //Call it so when user enters cloud screen, accounts are preloaded (bad!)
    driveUsecases.requestGoogleAccountSilent();
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
                values: <int, String>{
                  1: AppLocalizations.of(context)!.order_low_good,
                  2: AppLocalizations.of(context)!.order_low_bad
                },
                onChange: _clickChangeOrderingMode,
              ),
            ],
          ),
          SettingsGroup(
            title: AppLocalizations.of(context)!.cloud_storage,
            children: [
              SimpleSettingsTile(
                title: "Cloud Speicher konfigurieren",
                onTap: _clickOpenCloud,
              ),
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
            title: AppLocalizations.of(context)!.debug,
            children: [
              SimpleSettingsTile(
                title: AppLocalizations.of(context)!.upload_logs_to_drive,
                onTap: () async {
                  _uploadToGoogleDriveLogs(await FLog.exportLogs());
                },
                enabled: !kReleaseMode,
              ),
              SimpleSettingsTile(
                title: AppLocalizations.of(context)!.clear_logs,
                onTap: () async {
                  FLog.clearLogs();
                },
                enabled: !kReleaseMode,
              ),
              SimpleSettingsTile(
                title: AppLocalizations.of(context)!.show_logs,
                onTap: () async {
                  _clickViewLogs();
                },
                enabled: !kReleaseMode,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
