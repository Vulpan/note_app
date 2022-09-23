import 'dart:ui';

import 'package:hive/hive.dart';

import 'note_model.dart';

part 'briefcase_model.g.dart';

@HiveType(typeId: 1)
class Briefcase extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late List<Note> notes;

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

  @HiveField(8)
  late Color iconColor;

  Briefcase({
    required this.id,
    required this.title,
    required this.notes,
    required this.creationDate,
    required this.lastEditionDate,
    required this.color,
    required this.secondColor,
    required this.textColor,
    required this.iconColor,
  });

  Briefcase.empty({
    this.id = -1,
    this.title = "",
    List<Note>? notes,
    DateTime? creationDate,
    DateTime? lastEditionDate,
    this.color = const Color.fromARGB(255, 255, 255, 255),
    this.secondColor = const Color.fromARGB(255, 255, 255, 255),
    this.textColor = const Color.fromARGB(255, 0, 0, 0),
    this.iconColor = const Color.fromARGB(255, 255, 208, 0),
  }) {
    this.notes = notes ?? [];
    this.creationDate = creationDate ?? DateTime.now();
    this.lastEditionDate = lastEditionDate ?? DateTime.now();
  }

  Briefcase.fromMap(Map map) {
    id = map['id'];
    title = map['title'];
    notes = map['notes'];
    color = map['color'];
    secondColor = map['secondColor'];
    textColor = map['textColor'];
    iconColor = map['iconColor'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'title': title,
      'notes': notes,
      'color': color,
      'secondColor': secondColor,
      'textColor': textColor,
      'iconColor': iconColor,
    };
    return map;
  }

  @override
  bool operator ==(other) {
    return (other is Briefcase) && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
