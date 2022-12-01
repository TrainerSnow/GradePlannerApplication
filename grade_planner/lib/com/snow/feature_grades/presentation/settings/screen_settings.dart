import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsScreen extends StatefulWidget {
  final String title;

  const SettingsScreen({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  late int orderMode;

  void _clickChangeOrderingMode(int value) async{
    Settings.setValue("order_mode", value);
    setState(() {
      orderMode = Settings.getValue("order_mode", defaultValue: 1)!;
    });
  }


  @override
  void initState() {
    setState(() {
      orderMode = Settings.getValue("order_mode", defaultValue: 1)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
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
        ],
      ),
    );
  }
}
