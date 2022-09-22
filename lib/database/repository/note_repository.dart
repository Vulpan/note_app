import 'package:note_app/database/hive_databse.dart';

import '../model/note_model.dart';

class NoteRepository {
  static final _dbObject = HiveDatabse();

  static init(String dbName) {
    _dbObject.init(dbName);
  }

  static add(Note note) => _dbObject.add(note);

  static update(Note note) => _dbObject.update(note);

  static get(int id) => _dbObject.get(id);

  static getAll() => _dbObject.getAll();

  static delete(int id) => _dbObject.delete(id);

  static deleteAll() => _dbObject.deleteAll();

  static getBoxListenable() => _dbObject.getBoxListenable();
}
