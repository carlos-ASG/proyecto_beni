import 'package:flutter/material.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';
import 'package:proyecto_final/galeriaInv.dart';
import 'package:proyecto_final/widgets/Colores.dart';

class AlbumInv extends StatelessWidget {
  final String idEvento;
  final String idUsuario;
  const AlbumInv({super.key, required this.idEvento, required this.idUsuario});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DB.consguirEvento(idEvento),
        builder: (context, evento) {
          if (evento.hasData) {
            return Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colores.azulClaro,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GaleriaInv(
                                          titulo: evento.data!['descripcion'],
                                          idEvento: idEvento,
                                          idUsuario: idUsuario,
                                        )));
                          },
                          child: FutureBuilder(
                              future: DB.extrarImagen(
                                  evento.data!['fotos'].isEmpty
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
                              })),
                      SizedBox(
                        width: 120,
                        child: Text(
                          evento.data!['descripcion'],
                          style: const TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
