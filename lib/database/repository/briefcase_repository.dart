import 'package:note_app/database/hive_databse.dart';
import 'package:note_app/database/model/briefcase_model.dart';

class BriefcaseRepository {
  static final _dbObject = HiveDatabse();

  static init(String dbName) {
    _dbObject.init(dbName);
  }

  static add(Briefcase briefcase) => _dbObject.add(briefcase);

  static update(Briefcase briefcase) => _dbObject.update(briefcase);

  static get(int id) => _dbObject.get(id);

  static getAll() => _dbObject.getAll();

  static delete(int id) => _dbObject.delete(id);

  static deleteAll() => _dbObject.deleteAll();

  static getBoxListenable() => _dbObject.getBoxListenable();
}
