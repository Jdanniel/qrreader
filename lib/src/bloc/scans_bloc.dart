

import 'dart:async';

import 'package:qrreader/src/bloc/validator.dart';
import 'package:qrreader/src/providers/db_provider.dart';

class ScansBloc with Validators {


  //patron Singleton
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){

    //Obtener Scans de la Base de Datos
    obtenerScans();

  }

  final _scansStreamController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream     => _scansStreamController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansStreamController.stream.transform(validarHttp);

  dispose(){
    _scansStreamController?.close();
  }

  //Obtener informacion
  obtenerScans() async {
    _scansStreamController.sink.add(await DBProvider.db.getAllScans());
  }

  //Nuevo Scan
  agregarScan(ScanModel scan) async{
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  //Borrar Scan
  borrarScan(int id) async{
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  //Borrar Todos
  borrarScanTodos() async {
    await DBProvider.db.deleteAllScan();
    obtenerScans();
  }

}

