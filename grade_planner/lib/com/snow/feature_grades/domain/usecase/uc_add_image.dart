import 'package:image_picker/image_picker.dart';

import '../repository/images_repository.dart';

class AddImage{
  final ImagesRepository repository;

  AddImage(this.repository);

  Future<void> call(XFile file, String newName){
    return repository.addImage(file, newName);
  }
}