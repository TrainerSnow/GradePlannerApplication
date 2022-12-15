import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../../main.dart';
import '../../../common/components/widget_two_button_dialog.dart';
import '../../domain/model/grade.dart';
import '../../domain/model/subject.dart';
import '../../domain/model/userpreferences.dart';
import '../../domain/usecase/__preferences_usecases.dart';
import '../../domain/usecase/__subject_usecases.dart';
import '../addGrade/screem_add_grade.dart';
import '../addSubject/screen_add_subject.dart';
import '../addYear/screen_add_year.dart';
import '../settings/screen_settings.dart' as screen;
import '../viewAllSubjects/screen_viewAllSubjects.dart';
import 'components/dialog_choose_year.dart';
import 'components/widget_row_grade.dart';
import 'components/widget_row_subject.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late PreferencesUsecases preferencesUsecases;
  late SubjectUsecases subUseCases;

  late Future<Iterable<Subject>> subjects;
  late Future<Iterable<Grade>> grades;

  late Future<double> average;

  /*
  State values
   */

  late Future<UserPreferences> userPrefs;
  Subject? deletedSubject;
  Grade? deletedGrade;
  bool useSubjects = true;

  void _clickAddGrade() async {
    var _ = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddGradeScreen(title: AppLocalizations.of(context)!.add_grade)));
    _onLoad();
  }

  void _clickAddSubject() async {
    var _ = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddFileScreen(title: AppLocalizations.of(context)!.add_subject)));
    _onLoad();
  }

  void _clickAddYear() async {
    var _ = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddYearScreen(title: AppLocalizations.of(context)!.add_year)));
    _onLoad();
  }

  void _clickViewAll() async {
    var _ = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenViewAllSubjects(title: AppLocalizations.of(context)!.view_all_subjects)));
    _onLoad();
  }

  _onLoad() async {
    setState(() {
      subjects = subUseCases.getRecentSubjects.call();
      grades = subUseCases.getRecentGrades.call();
      userPrefs = preferencesUsecases.getPreferences.call();
      average = subUseCases.getMeanAverage.call();
    });
    var prefs = await preferencesUsecases.getPreferences.call();
    var years = await subUseCases.getYears.call();

    if (prefs.currentYear.isEmpty || years.isEmpty) {
      _showYearDialog(false);
    }
  }

  _clickDeleteSubject(Subject subject) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TwoButtonDialog(
          title: AppLocalizations.of(context)!.confirm_deletion,
          text: sprintf(
            AppLocalizations.of(context)!.deletion_subject_x_info,
            [subject.name],
          ),
          positiveLable: AppLocalizations.of(context)!.confirm,
          negativeLable: AppLocalizations.of(context)!.cancel,
          onNegative: () {
            Navigator.of(context).pop();
          },
          onPositive: () {
            deletedSubject = subject;
            subUseCases.deleteSubject.call(subject).then((value) {
              _onLoad();
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  _clickDeleteGrade(Grade grade) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TwoButtonDialog(
          title: AppLocalizations.of(context)!.confirm_deletion,
          text: sprintf(
            AppLocalizations.of(context)!.deletion_grade_x_info,
            [grade.name],
          ),
          positiveLable: AppLocalizations.of(context)!.confirm,
          negativeLable: AppLocalizations.of(context)!.cancel,
          onNegative: () {
            Navigator.of(context).pop();
          },
          onPositive: () {
            deletedGrade = grade;
            subUseCases.deleteGrade.call(grade).then((value) {
              _onLoad();
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _clickChangeYear() async {
    _showYearDialog(true);
  }

  void _showYearDialog(bool dismissable) async {
    var years = (await subUseCases.getYears.call());
    var names = years.map((e) => e.name);
    var pref = (await userPrefs);
    var name = pref.currentYear;
    showDialog(
      barrierDismissible: dismissable,
      context: context,
      builder: (BuildContext context) {
        return ChooseYearDialog(
          yearNames: names.toList(),
          defaultName: name,
          onChange: (String? selected) {
            if (selected != null) {
              preferencesUsecases.updatePreferences.call(pref.copyWith(currentYear: selected));
              Navigator.of(context).pop();
              _onLoad();
            }
          },
          onAddClick: () {
            Navigator.of(context).pop();
            _clickAddYear();
          },
        );
      },
    );
  }

  void _onClickSettings() async {
    var _ = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen.SettingsScreen(title: AppLocalizations.of(context)!.settings)));
    _onLoad();
  }

  @override
  void initState() {
    super.initState();
    preferencesUsecases = provider.get<PreferencesUsecases>();
    subUseCases = provider.get<SubjectUsecases>();

    subjects = subUseCases.getRecentSubjects.call();
    grades = subUseCases.getRecentGrades.call();
    userPrefs = preferencesUsecases.getPreferences.call();
    average = subUseCases.getMeanAverage.call();

    _onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.app_name),
          actions: [IconButton(onPressed: _onClickSettings, icon: const Icon(Icons.settings))],
        ),
        floatingActionButton: SpeedDial(
          childMargin: const EdgeInsets.all(16),
          animatedIcon: AnimatedIcons.menu_home,
          children: [
            SpeedDialChild(
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              label: AppLocalizations.of(context)!.add_grade,
              child: Icon(
                Icons.numbers,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
              onTap: _clickAddGrade,
            ),
            SpeedDialChild(
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              label: AppLocalizations.of(context)!.add_subject,
              child: Icon(
                Icons.create_new_folder,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
              onTap: _clickAddSubject,
            ),
            SpeedDialChild(
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              label: AppLocalizations.of(context)!.add_year,
              child: Icon(
                Icons.calendar_month,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
              onTap: _clickAddYear,
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.current_year_),
                          FutureBuilder<UserPreferences>(
                            future: userPrefs,
                            builder: (BuildContext context, AsyncSnapshot<UserPreferences> value) {
                              if (value.hasData) {
                                if (value.data!.currentYear == "") {
                                  return Text(AppLocalizations.of(context)!.no_year_selected);
                                }
                                return Text(value.data!.currentYear);
                              } else {
                                return Text(AppLocalizations.of(context)!.no_year_selected);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.change_circle_outlined),
                            onPressed: _clickChangeYear,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    AppLocalizations.of(context)!.total_avg_grade_,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  FutureBuilder<double>(
                    future: average,
                    builder: (BuildContext context, AsyncSnapshot<double> shot) {
                      if (shot.hasData) {
                        return Countup(
                          begin: 0.0,
                          end: shot.data!,
                          precision: 1,
                          style: Theme.of(context).textTheme.displayLarge,
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(AppLocalizations.of(context)!.no_data_available),
                        );
                      }
                    },
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.recently_changed,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Expanded(
                        child: SizedBox(
                          width: 0,
                          height: 0,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: _clickViewAll,
                            child: Text(
                              AppLocalizations.of(context)!.show_all,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            useSubjects ? AppLocalizations.of(context)!.subjects : AppLocalizations.of(context)!.grades,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  useSubjects = !useSubjects;
                                });
                              },
                              icon: const Icon(Icons.change_circle_outlined))
                        ],
                      )
                    ],
                  ),
                  FutureBuilder<Iterable<Subject>>(
                    future: subjects,
                    builder: (BuildContext context, AsyncSnapshot<Iterable<Subject>> shot) {
                      if (useSubjects) {
                        if (shot.hasData) {
                          if (shot.data!.isNotEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (Subject subject in shot.data!)
                                  SubjectRow(
                                    subject: subject,
                                    onDelete: _clickDeleteSubject,
                                    isOverAverage: subUseCases.isOverAverage.callSubject(subject, Settings.getValue("order_mode", defaultValue: 1)!),
                                    onClick: (Subject _) {},
                                  )
                              ],
                            );
                          } else {
                            return Text(AppLocalizations.of(context)!.no_recent_activity);
                          }
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              AppLocalizations.of(context)!.no_subject_data_info,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      } else {
                        return const SizedBox(
                          height: 0,
                          width: 0,
                        );
                      }
                    },
                  ),
                  FutureBuilder<Iterable<Grade>>(
                    future: grades,
                    builder: (BuildContext context, AsyncSnapshot<Iterable<Grade>> shot) {
                      if (!useSubjects) {
                        if (shot.hasData) {
                          if (shot.data!.isNotEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (Grade grade in shot.data!)
                                  GradeRow(
                                    grade: grade,
                                    onDelete: _clickDeleteGrade,
                                    isOverAverage: subUseCases.isOverAverage.callGrade(grade, Settings.getValue("order_mode", defaultValue: 1)!),
                                    onClick: (Grade _) {},
                                  )
                              ],
                            );
                          } else {
                            return Text(AppLocalizations.of(context)!.no_recent_activity);
                          }
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              AppLocalizations.of(context)!.no_grade_data_found,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      } else {
                        return const SizedBox(
                          height: 0,
                          width: 0,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
