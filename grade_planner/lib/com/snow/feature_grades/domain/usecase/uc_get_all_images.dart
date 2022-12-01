import 'dart:io';

import 'package:grade_planner/com/snow/feature_grades/domain/repository/images_repository.dart';

class GetAllImages {
  ImagesRepository repository;

  GetAllImages(this.repository);

  List<File> call() {
    return repository.getImageFiles();
  }
}
