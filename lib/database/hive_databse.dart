import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/database/database_interface.dart';
import 'package:note_app/database/model/briefcase_model.dart';
import 'package:note_app/database/model/note_model.dart';
import 'package:note_app/utils/strings.dart';

class HiveDatabse implements DatabaseInterface {
  String _boxName = "";

  @override
  init(String dbName) => (_boxName = dbName);

  @override
  add(Object obj) {
    Box box = Hive.box(_boxName);

    Map<String, dynamic> map = getMapOfObject(obj);

    box.put(map['id'], obj);
  }

  @override
  update(Object obj) {
    Box box = Hive.box(_boxName);

    Map<String, dynamic> map = getMapOfObject(obj);

    box.put(map['id'], obj);
  }

  @override
  dynamic get(int objId) {
    Box box = Hive.box(_boxName);

    return box.get(objId);
    // return getObjectFromMap(box.get(objId));
  }

  @override
  List<dynamic> getAll() {
    Box box = Hive.box(_boxName);
    return getListOfObject(box);
  }

  @override
  delete(int objId) {
    Box box = Hive.box(_boxName);
    box.delete(objId);
  }

  @override
  deleteAll() {
    Box box = Hive.box(_boxName);
    for (int i = 0; i < box.length; i++) {
      box.delete(box.getAt(i));
    }
  }

  @override
  ValueListenable getBoxListenable() {
    Box box = Hive.box(_boxName);
    return box.listenable();
  }

  Map<String, dynamic> getMapOfObject(Object obj) {
    if (StringConstants.noteModelBoxName == _boxName) {
      Note note = obj as Note;
      return note.toMap();
    } else if (StringConstants.briefcaseModelBoxName == _boxName) {
      Briefcase briefcase = obj as Briefcase;
      return briefcase.toMap();
    }
    return {};
  }

  // dynamic getObjectFromMap(dynamic obj) {
  //   if (StringConstants.noteModelBoxName == _boxName) {
  //     Note note = Note.fromMap(obj);
  //     return note;
  //   } else if (StringConstants.briefcaseModelBoxName == _boxName) {
  //     Briefcase briefcase = Briefcase.fromMap(obj);
  //     return briefcase;
  //   }
  // }

  List<dynamic> getListOfObject(Box box) {
    List<dynamic> list = [];
    if (StringConstants.noteModelBoxName == _boxName) {
      for (int i = 0; i < box.length; i++) {
        Note note = box.getAt(i);
        list.add(note);
        // Note note = getObjectFromMap(box.getAt(i));
        // list.add(getObjectFromMap(note));
      }
    } else if (StringConstants.briefcaseModelBoxName == _boxName) {
      for (int i = 0; i < box.length; i++) {
        Briefcase briefcase = box.getAt(i);
        list.add(briefcase);
      }
    }

    return list;
  }
}
