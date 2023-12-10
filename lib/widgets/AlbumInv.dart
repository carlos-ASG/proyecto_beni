import 'package:flutter/material.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';
import 'package:proyecto_final/galeriaInv.dart';
import 'package:proyecto_final/widgets/Colores.dart';

class AlbumInv extends StatelessWidget {
  final String idEvento;
  const AlbumInv({super.key, required this.idEvento});

  @override
  Widget build(BuildContext context) {
    Widget? imagen;
    return FutureBuilder(
        future: DB.consguirEvento(idEvento),
        builder: (context, evento) {
          if (evento.hasData) {
            if (evento.data?['fotos'].isEmpty) {
              try {
                imagen = Image.network(
                  evento.data!['fotos'][0],
                  width: 130,
                );
              } catch (e) {
                imagen = Image.asset(
                  'assets/foto.jpeg',
                  width: 130,
                );
              }
            } else {
              imagen = Image.asset(
                'assets/foto.jpeg',
                width: 130,
              );
            }
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
                                        )));
                          },
                          child: imagen!),
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
