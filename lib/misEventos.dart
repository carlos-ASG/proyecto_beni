import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_final/DB/models/eventos.dart';
import 'package:proyecto_final/widgets/AlbumMisEventos.dart';
import  'package:proyecto_final/widgets/Colores.dart';

import 'DB/serviciosRemotos.dart';
import 'login.dart';

Widget misEventos(State<Login> puntero,String idUsuario) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Puedes agregar o ver eventos",style: TextStyle(color: Colores.rosaOscuro,fontSize: 18),),
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.event), text: "Mis eventos"),
            Tab(icon: Icon(Icons.add), text: "Nuevo evento"),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          mostrar(idUsuario),
          //mostrar2(),// Widget para mostrar eventos
          capturar(idUsuario: idUsuario), // Widget para capturar nuevos eventos
        ],
      ),
    ),
  );

}
class capturar extends StatefulWidget {
  final String idUsuario;

  capturar({required this.idUsuario});

  @override
  _capturarState createState() => _capturarState();
}

class _capturarState extends State<capturar> {
  TextEditingController _descripcion = TextEditingController();
  TextEditingController _numeroevento = TextEditingController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  late var pickedFile;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null)
      setState(() {
        if (isStartDate) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(50),
      children: [
        TextField(
          controller: _numeroevento,
          decoration: InputDecoration(
            labelText: 'Nombre del evento',
            prefixIcon: Icon(Icons.edit),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _descripcion,
          decoration: InputDecoration(
            labelText: 'Descripción',
            prefixIcon: Icon(Icons.edit_note_sharp),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _selectDate(context, true),
          child: Text(_fechaInicio == null
              ? 'Fecha de inicio'
              : 'Fecha de inicio: ${_fechaInicio.toString()}'),
        ),
        ElevatedButton(
          onPressed: () => _selectDate(context, false),
          child: Text(_fechaFin == null
              ? 'Fecha de fin'
              : 'Fecha de fin: ${_fechaFin.toString()}'),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FilledButton(
              onPressed: () async {
                if (_descripcion.text.isNotEmpty && _fechaInicio != null && _fechaFin != null && _numeroevento.text.isNotEmpty) {
                  Timestamp fechaInicioTimestamp = Timestamp.fromDate(_fechaInicio!);
                  Timestamp fechaFinTimestamp = Timestamp.fromDate(_fechaFin!);
                  // Obtener la URL de la imagen desde Firebase Storage
                  //String fotoUrl = await DB.extrarImagen('1000123702.jpg');
                  // Cargar la imagen desde assets
                  ByteData data = await rootBundle.load('assets/error.jpeg');
                  List<int> bytes = data.buffer.asUint8List();
                  String fotoUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';

                  var temp = Evento(
                    descripcion: _descripcion.text,
                    fechaIni: fechaInicioTimestamp,
                    fechaFin: fechaFinTimestamp,
                    numeroEvento: _numeroevento.text, // Generar código aleatorio
                    editable: true,
                    fotos: [fotoUrl],
                  );
                  
                  DB.crearEvento(temp, widget.idUsuario);
                  setState(() {
                    _fechaInicio = null;
                    _fechaFin = null;
                    _descripcion.clear();
                    _numeroevento.clear();
                  });DefaultTabController.of(context)!.animateTo(0);
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Faltan datos por llenar'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Guardar'),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _fechaInicio = null;
                  _fechaFin = null;
                  _descripcion.clear();
                });
              },
              child: Text('Limpiar'),
            ),
          ],
        )
      ],
    );
  }
}
Widget mostrar(String idUsuario){
  return FutureBuilder(
    future: DB.conseguirUsuarios(idUsuario),
    builder: (context, usuario) {
      if (usuario.hasData) {
        List idEventos = usuario.data?['eventos_propios'];
        return ListView.builder(
            itemCount: idEventos.length,
            itemBuilder: (context, indice) {
              return Row(
                children: [
                  SizedBox(width: 101),
                  AlbumMisEventos(idEvento: idEventos[indice],idUsuario:idUsuario),
                  SizedBox(
                    width: 100,
                  )
                ],
              );
            });
      }
      return const Center(child: CircularProgressIndicator());
    },
  );
}
