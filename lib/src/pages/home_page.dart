import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _callPage(),
      bottomNavigationBar: _crearBottomNavigationBar(),
    );
  }

  Widget _callPage(int paginaActual){
    
  }

  Widget _crearBottomNavigationBar(){
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index){},
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