import 'dart:io';
import 'package:path/path.dart';

import 'package:grade_planner/com/snow/feature_grades/domain/model/grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_all_images.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_preferences.dart';

class GetImagesForGrade{
  GetAllImages getAllImages;
  GetPreferences getPreferences;

  GetImagesForGrade(this.getAllImages, this.getPreferences);

  Future<List<File>> call(Grade grade, Subject subject) async{
    var imagesToReturn = <File>[];
    var images = getAllImages.call();
    var preferences = await getPreferences.call();

    for(File image in images){
      var name = basenameWithoutExtension(image.path);

      var parts = name.split("-");

      if(parts.length == 5){
        if(
        parts[0] == preferences.currentYear &&
        parts[1] == subject.name &&
        parts[3] == grade.name
        ){
          imagesToReturn.add(image);
        }
      }
    }

    return imagesToReturn;
  }
}