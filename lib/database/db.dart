import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();

  static final DB instance = DB._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'quilometragem.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_veiculosSalvos);
  }

  String get _veiculosSalvos => '''
  CREATE TABLE veiculosSalvos(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    viagem VARCHAR(500),
    quilometragem DOUBLE, 
    motorista VARCHAR(200),
    destino VARCHAR(500),
    inicio VARCHAR(500),
    foto VARCHAR(500)
  );
''';


  Future<void> inserirVeiculo(String viagem,double quilometragem, String motorista,String inicio, String destino, String fotoPath) async {
    final db = await _database;
    await db!.insert('veiculosSalvos', {
      'viagem' : viagem,
      'quilometragem': quilometragem,
      'motorista': motorista,
      'inicio' : inicio,
      'destino': destino,
      'foto': fotoPath,
    });
  }

}
