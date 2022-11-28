import 'package:grade_planner/com/snow/feature_grades/domain/repository/images_repository.dart';

class DeleteCache{
  ImagesRepository repository;

  DeleteCache(this.repository);

  Future<void> call(){
    return repository.clearCache();
  }
}