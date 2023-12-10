import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta_meta.dart';
import  'package:proyecto_final/widgets/Colores.dart';

Widget misEventos(State puntero) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        //title: Text("Eventos"),
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.event), text: "Mis eventos"),
            Tab(icon: Icon(Icons.add), text: "Nuevo evento"),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          mostrar(), // Widget para mostrar eventos
          capturar(), // Widget para capturar nuevos eventos
        ],
      ),
    ),
  );

}

Widget capturar() {
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  return ListView(
    padding: EdgeInsets.all(50),
    children: [
      TextField(
        decoration: InputDecoration(
          labelText: 'Descripción',
          prefixIcon: Icon(Icons.edit_note_sharp, color: Colores.azulOscuro),
        ),
      ),
      TextField(
        decoration: InputDecoration(
          labelText: 'Fecha de inicio',
          prefixIcon: Icon(Icons.event, color:Colores.azulOscuro),
        ),
      ),
      TextField(
        decoration: InputDecoration(
          labelText: 'Fecha de fin',
          prefixIcon: Icon(Icons.event, color: Colores.azulOscuro)),
        ),
      ElevatedButton(
          onPressed: ()async{
            /*final pickedFile = await _picker.getImage(source: ImageSource.gallery);
            setState(() {
              _imageFile = pickedFile;
            });*/
          },
          child: Text('Seleccionar imagen'),
      )
      ,SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilledButton(
              onPressed: (){},
              child: Text('Guardar'),
          ),
          OutlinedButton(
              onPressed: (){},
              child: Text('Limpiar'),
          ),
        ],
      )
    ],
  );
}
Widget mostrar(){
  return ListView(
    padding:  EdgeInsets.all(50),
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const Text("Evento 1"),
            ],
          ),
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const Text("Evento 2"),
            ],

          ),
        ],
      ),
    ],
  );
}
