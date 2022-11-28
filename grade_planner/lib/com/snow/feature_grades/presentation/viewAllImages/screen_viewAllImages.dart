import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/__images_usecases.dart';
import 'package:grade_planner/main.dart';

import '../../domain/usecase/__subject_usecases.dart';

class ScreenViewAllImages extends StatefulWidget {
  final String title;
  final Grade grade;
  final Subject subject;
  final ImagesUsecases imagesUsecases = provider.get<ImagesUsecases>();
  final SubjectUsecases subjectUsecases = provider.get<SubjectUsecases>();

  ScreenViewAllImages({super.key, required this.title, required this.grade, required this.subject});

  @override
  State<StatefulWidget> createState() => _ScreenViewAllImagesState();
}

class _ScreenViewAllImagesState extends State<ScreenViewAllImages> {
  late Future<List<File>> imageFiles;

  int currentIndex = 0;

  @override
  void initState() {
    setState(() {
      imageFiles = widget.imagesUsecases.getImagesForGrade.call(widget.grade, widget.subject);
    });
  }

  void _nextImage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _deleteCurrentPhoto() async {
    var _ = (await imageFiles)[currentIndex].delete();

    widget.subjectUsecases.updateGrade.call(widget.grade.copyWith(numPhotos: widget.grade.numPhotos - 1));

    setState(() {
      imageFiles = widget.imagesUsecases.getImagesForGrade.call(widget.grade, widget.subject);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Images in ${widget.grade.name}",
        ),
        actions: [
          IconButton(
            onPressed: _deleteCurrentPhoto,
            icon: const Icon(Icons.delete_outline),
          )
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<List<File>>(
              future: imageFiles,
              builder: (BuildContext context, AsyncSnapshot<List<File>> shot) {
                if (shot.hasData) {
                  if (shot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("No Images for this grade found"),
                    );
                  } else {
                    return ImageSlideshow(
                      onPageChanged: _nextImage,
                      height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!,
                      children: [for (File image in shot.data!) Image.file(image)],
                    );
                  }
                } else {
                  return const SizedBox(width: 0, height: 0);
                }
              })
        ],
      ),
    );
  }
}
