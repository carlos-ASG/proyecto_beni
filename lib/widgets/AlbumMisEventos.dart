import 'package:flutter/material.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';
import 'package:proyecto_final/galeriaInv.dart';
import 'package:proyecto_final/galeriaPropios.dart';
import 'package:proyecto_final/widgets/Colores.dart';

class AlbumMisEventos extends StatefulWidget {
  final String idEvento;
  final String idUsuario;

  const AlbumMisEventos(
      {Key? key, required this.idEvento, required this.idUsuario})
      : super(key: key);

  @override
  _AlbumMisEventosState createState() => _AlbumMisEventosState();
}

class _AlbumMisEventosState extends State<AlbumMisEventos> {
  bool editable = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DB.consguirEvento(widget.idEvento),
      builder: (context, evento) {
        if (evento.hasData) {
          return Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colores.azulCian,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GaleriaPropios(
                              titulo: evento.data!['descripcion'],
                              idEvento: widget.idEvento,
                              editable: evento.data!['editable'],
                              idUsuario: widget.idUsuario,
                              numeroEvento: evento.data!['numero_evento']),
                        ),
                      );
                    },
                    child: FutureBuilder(
                      future: DB.extrarImagen(evento.data!['fotos'].isEmpty
                          ? ""
                          : evento.data!['fotos'][0]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          if (snapshot.error != null) {
                            return Image.asset(
                              'assets/error.jpeg',
                              fit: BoxFit.cover,
                            );
                          } else if (snapshot.data != null) {
                            return Image.network(
                              snapshot.data,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Image.asset(
                              'assets/defecto.jpeg',
                              fit: BoxFit.cover,
                            );
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Text(
                      evento.data!['descripcion'],
                      style: const TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
