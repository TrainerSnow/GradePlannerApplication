import 'dart:io';

import 'package:grade_planner/com/snow/feature_grades/data/source/images_database.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/repository/images_repository.dart';
import 'package:image_picker/image_picker.dart';

class ImagesRepositoryImpl extends ImagesRepository{

  ImagesDatabase database;


  ImagesRepositoryImpl(this.database);

  @override
  Future<void> addImage(XFile file, String newName) {
    return database.addImage(file, newName);
  }

  @override
  Future<void> clearCache() {
    return database.clearCache();
  }

  @override
  List<File> getImageFiles() {
    return database.getImages();
  }

}