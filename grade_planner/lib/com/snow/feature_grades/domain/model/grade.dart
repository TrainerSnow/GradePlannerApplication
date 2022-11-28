import 'package:json_annotation/json_annotation.dart';

part 'grade.g.dart';

@JsonSerializable()
class Grade {
  double value;
  String name;
  int createdAt;

  int numPhotos;

  String groupName;
  String subjectName;

  Grade({required this.value, required this.name, required this.createdAt, required this.groupName, required this.subjectName, required this.numPhotos});

  factory Grade.fromJson(Map<String, dynamic> json) => _$GradeFromJson(json);

  Map<String, dynamic> toJson() => _$GradeToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Grade && runtimeType == other.runtimeType && value == other.value && name == other.name && createdAt == other.createdAt && numPhotos == other.numPhotos && groupName == other.groupName && subjectName == other.subjectName;

  @override
  int get hashCode => value.hashCode ^ name.hashCode ^ createdAt.hashCode ^ numPhotos.hashCode ^ groupName.hashCode ^ subjectName.hashCode;

  Grade copyWith({
    double? value,
    String? name,
    int? createdAt,
    int? numPhotos,
    String? groupName,
    String? subjectName,
  }) {
    return Grade(
      value: value ?? this.value,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      numPhotos: numPhotos ?? this.numPhotos,
      groupName: groupName ?? this.groupName,
      subjectName: subjectName ?? this.subjectName,
    );
  }
}
