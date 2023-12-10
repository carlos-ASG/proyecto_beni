import 'package:flutter/material.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';
import 'package:proyecto_final/galeriaInv.dart';
import 'package:proyecto_final/galeriaPropios.dart';
import 'package:proyecto_final/widgets/Colores.dart';

class AlbumMisEventos extends StatefulWidget {
  final String idEvento;
  final String idUsuario;

  AlbumMisEventos({Key? key, required this.idEvento, required this.idUsuario})
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
          bool eventoEditable = evento.data!['editable'] ?? false;
          editable = eventoEditable;

          String buttonText =
          editable ? 'Bloquear edición del evento' : 'Permitir edición del evento';

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
                          final RenderBox button =
                          context.findRenderObject() as RenderBox;
                          final Offset buttonPosition =
                          button.localToGlobal(Offset.zero);
                          final double top =
                              buttonPosition.dy - 280 + button.size.height;
                          final double left = buttonPosition.dx;
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(left, top, 0, 0),
                            items: [
                              PopupMenuItem(
                                child: Text(buttonText),
                                value: 1,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            'Confirmar ${editable ? 'bloqueo' : 'desbloqueo'}'),
                                        content: Text(
                                          '¿Estás seguro de que quieres ${editable ? 'bloquear' : 'permitir la edición de'} este evento?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (editable) {
                                                DB.bloquearEvento(widget.idEvento);
                                                mostrarConfirmacion(
                                                    context, "bloqueado");
                                              } else {
                                                DB.desbloquearEvento(widget.idEvento);
                                                mostrarConfirmacion(
                                                    context, "desbloqueado");
                                              }

                                              toggleEditable();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(editable ? 'Bloquear' : 'Permitir'),
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
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirmar eliminación'),
                                        content: Text(
                                            '¿Estás seguro de que quieres eliminar este evento?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              DB.eliminarEvento(
                                                  widget.idEvento, widget.idUsuario);
                                              mostrarConfirmacion(
                                                  context, "eliminado");
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Eliminar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
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
                              idEvento: widget.idEvento,
                            ),
                          ),
                        );
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
                            return Image.network(
                              snapshot.data,
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

  void toggleEditable() {
    setState(() {
      editable = !editable;
    });
  }

  void mostrarConfirmacion(BuildContext context, String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('El evento ha sido $accion'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
