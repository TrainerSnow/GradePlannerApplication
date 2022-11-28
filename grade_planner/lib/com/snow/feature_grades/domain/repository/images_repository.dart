import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class ImagesRepository{
  Future<void> addImage(XFile file, String newName);

  Future<void> clearCache();

  List<File> getImageFiles();
}