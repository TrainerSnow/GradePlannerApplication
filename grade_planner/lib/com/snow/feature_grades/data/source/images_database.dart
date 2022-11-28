import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../di/injecting.dart';

class ImagesDatabase{
  final Directory imagesDir;

  ImagesDatabase(this.imagesDir);

  Future<void> addImage(XFile file, String newName) async{
    var byteData = await file.readAsBytes();
    var path = "${imagesDir.path}/$newName${_getExtension(file.path)}";

    var newFile = File(path);
    if(await newFile.exists()){
      newFile.delete();
    }

    newFile.create();
    newFile.writeAsBytes(byteData);

    return;
  }

  List<File> getImages(){
    var files = imagesDir.listSync().whereType<File>().toList();
    return files;
  }

  Future<void> clearCache() async{
    var appDir = (await getTemporaryDirectory()).path;
    Directory(appDir).delete(recursive: true);
  }

  String _getExtension(String path){
    var extension = p.extension(path);
    return extension;
  }
}