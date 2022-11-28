
import 'dart:io';

import 'package:grade_planner/com/snow/feature_grades/domain/model/grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_images_for_subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_preferences.dart';
import 'package:path/path.dart';

import '../../../di/injecting.dart';

class DeleteImageByGrade{
  GetImagesForGrade getImagesForGrade;
  GetPreferences getPreferences;

  DeleteImageByGrade(this.getImagesForGrade, this.getPreferences);

  Future<void> call(Grade grade, Subject subject, int index) async{
    log.wtf(
      """
      Will delete photo with
      Grade = ${grade.toJson()}
      Subject = ${subject.toJson()}
      index = $index
      """
    );
    var prefs = await getPreferences.call();
    var images = await getImagesForGrade.call(grade, subject);

    for(File image in images){
      var parts = basenameWithoutExtension(image.path).split("-");

      if(parts.length == 5){
        if(
        parts[0] == prefs.currentYear &&
        parts[1] == subject.name &&
        parts[3] == grade.name &&
        parts[4] == index.toString()
        ){
          log.i("Found image that matches conditions: $image");
          image.delete();
        }
      }
    }
  }
}