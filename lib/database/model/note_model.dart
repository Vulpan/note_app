import 'dart:ui';

import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String content;

  @HiveField(3)
  late DateTime creationDate;

  @HiveField(4)
  late DateTime lastEditionDate;

  @HiveField(5)
  late Color color;

  @HiveField(6)
  late Color secondColor;

  @HiveField(7)
  late Color textColor;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.creationDate,
    required this.lastEditionDate,
    required this.color,
    required this.secondColor,
    required this.textColor,
  });

  Note.empty({
    this.id = -1,
    this.title = "",
    this.content = "",
    DateTime? creationDate,
    DateTime? lastEditionDate,
    this.color = const Color.fromARGB(255, 255, 255, 255),
    this.secondColor = const Color.fromARGB(255, 0, 0, 0),
    this.textColor = const Color.fromARGB(255, 0, 0, 0),
  }) {
    this.creationDate = creationDate ?? DateTime.now();
    this.lastEditionDate = lastEditionDate ?? DateTime.now();
  }

  Note.fromMap(Map map) {
    id = map['id'];
    title = map['title'];
    content = map['content'];
    creationDate = map['creationDate'];
    lastEditionDate = map['lastEditionDate'];
    color = map['color'];
    secondColor = map['secondColor'];
    textColor = map['textColor'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'title': title,
      'content': content,
      'creationDate': creationDate,
      'lastEditionDate': lastEditionDate,
      'color': color,
      'secondColor': secondColor,
      'textColor': textColor,
    };
    return map;
  }

  @override
  bool operator ==(other) {
    return (other is Note) && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
