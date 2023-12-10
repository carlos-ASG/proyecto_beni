import 'package:flutter/material.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';
import 'package:proyecto_final/galeriaInv.dart';
import 'package:proyecto_final/galeriaPropios.dart';
import 'package:proyecto_final/widgets/Colores.dart';

class AlbumMisEventos extends StatelessWidget {
  final String idEvento;
  const AlbumMisEventos({super.key, required this.idEvento});

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
                    color: Colores.azulCian,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GaleriaPropios(
                                          titulo: evento.data!['descripcion'],
                                          idEvento: idEvento,
                                        )));
                          },
                          child: FutureBuilder(
                              future: DB.extrarImagen(evento.data!['fotos'][0]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  if (snapshot.error != null) {
                                    return Image.asset('assets/foto.jpeg');
                                  } else {
                                    return //GestureDetector(
                                        //onTap: () {},
                                        /*child:*/ Image.network(
                                      snapshot.data,
                                      fit: BoxFit.cover,
                                      //),
                                    );
                                  }
                                }
                              }),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert), // Ícono de tres puntos
                        onPressed: () {
                          // Aquí puedes agregar la lógica para mostrar el menú emergente
                          // Puedes usar un PopupMenuButton o showDialog para un menú personalizado.
                          // Ejemplo usando PopupMenuButton:
                          showMenu(
                            context: context,
                            position: RelativeRect.fromRect(
                              Rect.fromPoints(
                                Offset(100, 100), // Posición inicial del menú emergente
                                Offset(200, 200), // Posición final del menú emergente
                              ),
                              Offset.zero & MediaQuery.of(context).size,
                            ),
                            items: [
                              PopupMenuItem(
                                child: Text('Opción 1'),
                                value: 1,
                              ),
                              PopupMenuItem(
                                child: Text('Opción 2'),
                                value: 2,
                              ),
                              // Puedes agregar más opciones según tus necesidades
                            ],
                            elevation: 8.0,
                          );
                        },
                      ),
                      SizedBox(
                        width: 120,
                        child: Text(
                          evento.data!['descripcion'],
                          style: const TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
