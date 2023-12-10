import 'package:flutter/material.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';
import 'package:proyecto_final/galeriaInv.dart';
import 'package:proyecto_final/galeriaPropios.dart';
import 'package:proyecto_final/widgets/Colores.dart';

class AlbumMisEventos extends StatelessWidget {
  final String idEvento;
  final String idUsuario;
  const AlbumMisEventos({super.key, required this.idEvento,required this.idUsuario});

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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              final RenderBox button = context.findRenderObject() as RenderBox;
                              final Offset buttonPosition = button.localToGlobal(Offset.zero);
                              final double top = buttonPosition.dy-280 + button.size.height;
                              final double left = buttonPosition.dx;
                              showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(left, top, 0, 0),
                                items: [
                                  PopupMenuItem(
                                    child: Text('Bloquear edición de evento'),
                                    value: 1,
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirmar bloqueo'),
                                            content: Text('¿Estás seguro de que quieres bloquear este evento?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {

                                                  Navigator.of(context).pop(); // Cierra el cuadro de diálogo de confirmación
                                                },
                                                child: Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  DB.bloquearEvento(idEvento);
                                                  mostrarConfirmacion(context,"bloqueado");
                                                  Navigator.of(context).pop(); // Cierra el cuadro de diálogo de confirmación

                                                },
                                                child: Text('Bloquear'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Text('Eliminar evento'),
                                    value: 2,
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirmar eliminación'),
                                            content: Text('¿Estás seguro de que quieres eliminar este evento?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Cierra el cuadro de diálogo de confirmación
                                                },
                                                child: Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  DB.eliminarEvento(idEvento,idUsuario);
                                                  mostrarConfirmacion(context,"eliminado");
                                                  Navigator.of(context).pop(); // Cierra el cuadro de diálogo de confirmación

                                                },
                                                child: Text('Eliminar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      }
                                  ),

                                ],
                                elevation: 8.0,
                              );
                            },
                          ),
                        ],
                      ),
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

    void mostrarConfirmacion(BuildContext context,String accion) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El evento ha sido ${accion}'),
          duration: Duration(seconds: 3), // Duración del mensaje en segundos
        ),
      );
    }

}
