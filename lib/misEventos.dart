import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_final/DB/models/eventos.dart';
import 'package:proyecto_final/widgets/AlbumMisEventos.dart';
import 'package:proyecto_final/widgets/Colores.dart';

import 'DB/serviciosRemotos.dart';
import 'login.dart';

Widget misEventos(State<Login> puntero, String idUsuario) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Puedes agregar o ver eventos",
          style: TextStyle(color: Colores.rosaOscuro, fontSize: 18),
        ),
        bottom: const TabBar(
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

  const capturar({super.key, required this.idUsuario});

  @override
  _capturarState createState() => _capturarState();
}

class _capturarState extends State<capturar> {
  final TextEditingController _descripcion = TextEditingController();
  String numEvento = "Genera número de evento.";
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
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(45),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                String generarCodigoAleatorio(int longitud) {
                  const caracteres =
                      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
                  final random = Random();

                  return String.fromCharCodes(
                    List.generate(
                        longitud,
                        (index) => caracteres
                            .codeUnitAt(random.nextInt(caracteres.length))),
                  );
                }

                setState(() {
                  numEvento = generarCodigoAleatorio(8);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.edit,
                    color: Colores.azulOscuro,
                  ),
                  Text(
                    numEvento,
                    style: TextStyle(color: Colores.azulOscuro),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  if (numEvento != "Genera número de evento.") {
                    Clipboard.setData(ClipboardData(text: numEvento));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Número de evento copiado'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.copy)),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descripcion,
          decoration: const InputDecoration(
            labelText: 'Descripción',
            prefixIcon: Icon(Icons.edit_note_sharp),
          ),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FilledButton(
              onPressed: () async {
                if (_descripcion.text.isNotEmpty &&
                    _fechaInicio != null &&
                    _fechaFin != null &&
                    numEvento != "Genera número de evento.") {
                  Timestamp fechaInicioTimestamp =
                      Timestamp.fromDate(_fechaInicio!);
                  Timestamp fechaFinTimestamp = Timestamp.fromDate(_fechaFin!);
                  // Obtener la URL de la imagen desde Firebase Storage
                  //String fotoUrl = await DB.extrarImagen('1000123702.jpg');
                  // Cargar la imagen desde assets
                  /*ByteData data = await rootBundle.load('assets/error.jpeg');
                  List<int> bytes = data.buffer.asUint8List();
                  String fotoUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                  */

                  var temp = Evento(
                    idUsuario: widget.idUsuario,
                    descripcion: _descripcion.text,
                    fechaIni: fechaInicioTimestamp,
                    fechaFin: fechaFinTimestamp,
                    numeroEvento: numEvento, // Generar código aleatorio
                    editable: true,
                    fotos: [],
                  );

                  DB.crearEvento(temp, widget.idUsuario);
                  setState(() {
                    _fechaInicio = null;
                    _fechaFin = null;
                    _descripcion.clear();
                    numEvento = "Genera número de evento.";
                  });
                  DefaultTabController.of(context).animateTo(0);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Faltan datos por llenar'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _fechaInicio = null;
                  _fechaFin = null;
                  _descripcion.clear();
                  _descripcion.clear();
                  numEvento = "Genera número de evento.";
                });
              },
              child: const Text('Limpiar'),
            ),
          ],
        )
      ],
    );
  }
}

Widget mostrar(String idUsuario) {
  return StreamBuilder(
    stream: fireStore.collection('usuario').doc(idUsuario).snapshots(),
    builder: (context, snapshot) {
      try {
        if (snapshot.hasData) {
          List idEventos = snapshot.data?['eventos_propios'];
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: idEventos.length,
            itemBuilder: (context, indice) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: AlbumMisEventos(
                                idEvento: idEventos[indice],
                                idUsuario: idUsuario),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      FutureBuilder(
                        future: DB.consguirEvento(idEventos[indice]),
                        builder: (context, evento) {
                          if (evento.hasData) {
                            String descripcion = evento.data?['descripcion'];
                            return Text(
                              descripcion,
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            );
                          }
                          return Container(); // Puedes cambiar esto según tu lógica de carga.
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Text("Aún no hay eventos");
        }
      } catch (e) {
        // Manejar la excepción según tus necesidades
        print("Error: $e");
        return const Text("Aún no hay eventos");
      }
      return const Center(child: CircularProgressIndicator());
    },
  );
}
