import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qrreader/src/bloc/scans_bloc.dart';
import 'package:qrreader/src/models/scan_model.dart';

import 'package:qrreader/src/pages/direcciones_page.dart';
import 'package:qrreader/src/pages/mapas_page.dart';

import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrreader/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansbloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => _deleteAllScans(),
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async {

    // https://google.com.mx

    //geo:40.764810317804454,-73.78896131953127

    String futureString = "https://google.com.mx";

    /*
      String futureString = "";

      try{
        futureString = await new QRCodeReader().scan();
      }catch(e){
        futureString = e.toString();
      }

      print('futureString: $futureString');
*/
      if(futureString != null){
        final scan = ScanModel(valor: futureString);
        scansbloc.agregarScan(scan);

        final scan2 = ScanModel(valor: 'geo:40.764810317804454,-73.78896131953127');
        scansbloc.agregarScan(scan2);

        if(Platform.isIOS){
          Future.delayed(Duration(milliseconds: 750),(){
            utils.abrirScan(context, scan);
          });
        }else{
          utils.abrirScan(context, scan);
        }
      }
  }

  _deleteAllScans() async{
    scansbloc.borrarScanTodos();
  }

  Widget _callPage(int paginaActual){
    switch (paginaActual) {
      case 0: return MapasPage();
      case 1: return DireccionesPage();
      default:
        return MapasPage();
    }
  }

  Widget _crearBottomNavigationBar(){
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
         currentIndex = index; 
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Maps')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),        
      ],
    );
  }
}