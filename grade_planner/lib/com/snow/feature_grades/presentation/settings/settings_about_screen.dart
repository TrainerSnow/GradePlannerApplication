import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const String PRIVACY_POLICY = "https://github.com/TrainerSnow/GradePlannerApplication/blob/master/PRIVACY_POLICY.md";
const String GITHUB_REPO = "https://github.com/TrainerSnow/GradePlannerApplication";

class SettingsABoutScreen extends StatefulWidget {
  final String title;

  const SettingsABoutScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<SettingsABoutScreen> createState() => _SettingsABoutScreenState();
}

class _SettingsABoutScreenState extends State<SettingsABoutScreen> {
  late Future<PackageInfo> packageInfo;

  @override
  void initState() {
    packageInfo = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          //TODO: Translate
          SettingsGroup(
            title: AppLocalizations.of(context)!.privacy,
            children: [
              SimpleSettingsTile(
                title: AppLocalizations.of(context)!.privacy_policy,
                subtitle: PRIVACY_POLICY,
                onTap: () {
                  launchUrl(Uri.parse(PRIVACY_POLICY));
                },
              ),
            ],
          ),
          SettingsGroup(
            title: AppLocalizations.of(context)!.open_source,
            children: [
              SimpleSettingsTile(
                title: AppLocalizations.of(context)!.github_repo,
                subtitle: GITHUB_REPO,
                onTap: () {
                  launchUrl(Uri.parse(GITHUB_REPO));
                },
              ),
            ],
          ),
          SettingsGroup(
            title: AppLocalizations.of(context)!.about_this_app,
            children: [
              FutureBuilder<PackageInfo>(
                  future: packageInfo,
                  builder: (BuildContext context, AsyncSnapshot<PackageInfo> shot) {
                    return SimpleSettingsTile(
                      title: AppLocalizations.of(context)!.app_name,
                      subtitle: shot.hasData ? shot.data!.appName : null,
                    );
                  }),
              FutureBuilder<PackageInfo>(
                  future: packageInfo,
                  builder: (BuildContext context, AsyncSnapshot<PackageInfo> shot) {
                    return SimpleSettingsTile(
                      title: AppLocalizations.of(context)!.package_name,
                      subtitle: shot.hasData ? shot.data!.packageName : null,
                    );
                  }),
              FutureBuilder<PackageInfo>(
                  future: packageInfo,
                  builder: (BuildContext context, AsyncSnapshot<PackageInfo> shot) {
                    return SimpleSettingsTile(
                      title: AppLocalizations.of(context)!.version,
                      subtitle: shot.hasData ? shot.data!.version : null,
                    );
                  }),
              FutureBuilder<PackageInfo>(
                  future: packageInfo,
                  builder: (BuildContext context, AsyncSnapshot<PackageInfo> shot) {
                    return SimpleSettingsTile(
                      title: AppLocalizations.of(context)!.build_version,
                      subtitle: shot.hasData ? shot.data!.buildNumber : null,
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
