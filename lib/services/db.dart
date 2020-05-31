import 'package:sqflite/sqflite.dart';

class DBClient {
  DBClient._();

  String favouritesTableName = "favourites";

  static final DBClient internal = DBClient._();

  factory DBClient() => internal;

  Database _database;

  Future<Database> get db async => await initDB();

  Future<Database> initDB() async {
    if (_database == null) {
      _database =
          await openDatabase('creator.db', version: 1, onCreate: _onCreate);
    }
    return _database;
  }

  void _onCreate(Database database, int version) async {
    await database.execute('''
    CREATE TABLE $favouritesTableName (
      id integer primary key,
      width integer,
      height integer,
      url text,
      photographer text,
      photographer_url text,
      photographer_id integer,
      src_from_db_medium text,
      src_from_db_original text
    );
    ''');
  }
}
