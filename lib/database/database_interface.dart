import 'package:flutter/foundation.dart';

abstract class DatabaseInterface {
  init(String dbName);

  add(Object obj);

  update(Object obj);

  dynamic get(int objId);

  List<dynamic> getAll();

  delete(int objId);

  deleteAll();

  ValueListenable getBoxListenable();
}
