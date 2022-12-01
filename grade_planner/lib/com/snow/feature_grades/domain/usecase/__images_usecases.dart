import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_add_image.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_clear_cache.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_delete_image_by_grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_all_images.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_images_for_subject.dart';

class ImagesUsecases {
  AddImage addImage;

  DeleteCache deleteCache;

  GetAllImages getAllImages;

  GetImagesForGrade getImagesForGrade;

  @deprecated
  DeleteImageByGrade deleteImageByGrade;

  ImagesUsecases({required this.addImage, required this.deleteCache, required this.getAllImages, required this.getImagesForGrade, required this.deleteImageByGrade});
}
