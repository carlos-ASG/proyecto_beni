import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta_meta.dart';
import  'package:proyecto_final/widgets/Colores.dart';
import 'package:proyecto_final/DB/models/eventos.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';


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
class capturar extends StatefulWidget {
  @override
  _capturarState createState() => _capturarState();
}

class _capturarState extends State<capturar> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _descripcion = TextEditingController();
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
          decoration: InputDecoration(
            labelText: 'Descripción',
            prefixIcon: Icon(Icons.edit_note_sharp, color: Colores.azulOscuro),
          ),
        ),SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _selectDate(context, true),
          child: Text(_fechaInicio == null ? 'Fecha de inicio' : 'Fecha de inicio: ${_fechaInicio.toString()}'),
        ),
        ElevatedButton(
          onPressed: () => _selectDate(context, false),
          child: Text(_fechaFin == null ? 'Fecha de fin' : 'Fecha de fin: ${_fechaFin.toString()}'),
        ),SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            ImagePicker picker = ImagePicker();
            _imageFile =
            await picker.pickImage(source: ImageSource.gallery);
          },
          child: Text('Seleccionar imagen'),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FilledButton(
              onPressed: (){
                Timestamp fechaInicioTimestamp = Timestamp.fromDate(_fechaInicio!);
                Timestamp fechaFinTimestamp = Timestamp.fromDate(_fechaFin!);
                var temp = Evento(
                  descripcion: _descripcion.text,
                  fechaIni: fechaInicioTimestamp,
                  fechaFin: fechaFinTimestamp,
                  numeroEvento: "",
                  editable: true, fotos: [],
                );
                DB.crearEvento(temp);
              },
              child: Text('Guardar'),
            ),
            OutlinedButton(
              onPressed: (){
                setState(() {
                  _imageFile = null;
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
Widget mostrar() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('evento').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Algo salió mal');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Cargando...");
      }

      return GridView.count(
        crossAxisCount: 2,
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          Evento evento = Evento.fromMap(data);
          String primeraImagen = evento.fotos[0];
          Image.network(evento.fotos.isNotEmpty ? evento.fotos[0] : 'url_de_imagen_predeterminada');
          return GridTile(
            child: Column(
              children: [
                Text(evento.descripcion),
                Image.network(primeraImagen), // Asegúrate de que 'fotos' no esté vacío
              ],
            ),
          );
        }).toList(),
      );
    },
  );
}
