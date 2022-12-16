import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/networking/__drive_usecases.dart';
import 'package:grade_planner/com/snow/feature_grades/presentation/settings/settings_about_screen.dart';
import 'package:grade_planner/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../di/injecting.dart';

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

  void _clickSignInGoogle() {
    setState(() {
      accountInfo = driveUsecases.signoutAndRequestGoogleAccount();
    });
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

  void _signInSilent() async {
    accountInfo = driveUsecases.requestGoogleAccountSilent();
  }

  void _uploadToGoogleDrive() async {
    final user = await driveUsecases.requestGoogleAccountSilent();
    if (user != null) {
      log.wtf("User: $user");
      driveUsecases.uploadCurrentToDrive(user);
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
                      title: AppLocalizations.of(context)!.upload_to_drive,
                      onTap: _clickSignInGoogle,
                    );
                  } else {
                    return SimpleSettingsTile(
                      title: AppLocalizations.of(context)!.upload_to_drive,
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
        ],
      ),
    );
  }
}
