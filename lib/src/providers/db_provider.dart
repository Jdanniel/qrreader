import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qrreader/src/models/scan_model.dart';
export 'package:qrreader/src/models/scan_model.dart';

class DBProvider {

  //Instancia de mi Base de Datos
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if(_database != null) return _database;

    _database = await initDB();

    return _database;

  }

  initDB() async{
    //Definir el path
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path,'ScansDb.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      }
    );
  }

  //Inserts
  nuevoScanRaw(ScanModel nuevoScan) async{

    final db  = await database;

    final res = await db.rawInsert(
      "INSERT INTO Scans (id,tipo,valor) "
      "VALUES (${nuevoScan.id},'${nuevoScan.tipo}', '${nuevoScan.valor}') "
    );
    return res;
  }

  nuevoScan(ScanModel nuevoScan) async {
    final db  = await database;

    final res = await db.insert('Scans', nuevoScan.toJson());

    return res;

  }

  //Selects
  Future<ScanModel> getScanId (int id) async {
    final db  = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db  = await database;
    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty 
                            ? res.map((s) => ScanModel.fromJson(s)).toList() 
                            : [];
    return list;
  }

  Future<List<ScanModel>> getAllScansPorTipo(String tipo) async {
    final db  = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo = '$tipo'");

    List<ScanModel> list = res.isNotEmpty 
                            ? res.map((s) => ScanModel.fromJson(s)).toList() 
                            : [];
    return list;
  }

  //Actualizar Registros
  Future<int> updateScan(ScanModel nuevoScan) async{
    final db  = await database;
    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);
    return res;
  }

  //Eliminar Registro

  Future<int> deleteScan(int id) async{
    final db  = await database;
    final res = await db.delete('Scans',where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllScan() async{
    final db  = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }

}