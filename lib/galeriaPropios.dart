import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';
import 'package:proyecto_final/widgets/Colores.dart';
import 'package:proyecto_final/widgets/imgGaleria.dart';

class GaleriaPropios extends StatefulWidget {
  final String titulo;
  final String idEvento;
  final String idUsuario;
  final String numeroEvento;
  final bool editable;

  const GaleriaPropios(
      {Key? key,
      required this.titulo,
      required this.idEvento,
      required this.editable,
      required this.idUsuario,
      required this.numeroEvento})
      : super(key: key);

  @override
  _GaleriaPropiosState createState() => _GaleriaPropiosState();
}

class _GaleriaPropiosState extends State<GaleriaPropios> {
  Future? datos;
  bool _isEditable = true;
  Icon candado = const Icon(Icons.lock_open);
  final bool eventoEditable = true;

  //String buttonText = widget.editable
  //   ? 'Bloquear edición del evento'
  //   : 'Permitir edición del evento';

  @override
  void initState() {
    setState(() {
      _isEditable = widget.editable;
    });
    super.initState();
    datos = DB.consguirEvento(
        widget.idEvento); // Reemplaza esto con tu función para obtener datos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Colores.azulClaro,
        actions: [
          IconButton(
            icon: _isEditable
                ? candado = const Icon(Icons.lock_open)
                : candado = const Icon(Icons.lock),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Confirmar ${_isEditable ? 'bloqueo' : 'desbloqueo'}',
                    ),
                    content: Text(
                      '¿Estás seguro de que quieres ${_isEditable ? 'bloquear' : 'permitir la edición de'} este evento?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_isEditable) {
                            setState(() {
                              DB.bloquearEvento(widget.idEvento);
                            });
                            mostrarConfirmacion(context, "bloqueado");
                          } else {
                            setState(() {
                              DB.desbloquearEvento(widget.idEvento);
                            });
                            mostrarConfirmacion(context, "desbloqueado");
                          }
                          setState(() {
                            _isEditable = !_isEditable;
                          });

                          Navigator.of(context).pop();
                        },
                        child: Text(_isEditable ? 'Bloquear' : 'Desbloquear'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Confirmar eliminación',
                    ),
                    content: const Text(
                      '¿Estás seguro de que quieres eliminar este evento?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          DB.eliminarEvento(widget.idEvento, widget.idUsuario);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          mostrarConfirmacion(context, "eliminado");
                        },
                        child: const Text(
                          "Eliminar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Número de evento',
                      ),
                      content: Text(
                        'El número de invitación al evento es: ${widget.numeroEvento}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.numbers))
        ],
      ),
      body: FutureBuilder(
          future: datos,
          builder: (context, evento) {
            if (evento.hasData) {
              List imagenes = evento.data!['fotos'];
              return GridView.builder(
                  //extent(maxCrossAxisExtent: 150),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150.0,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4),
                  padding: const EdgeInsets.all(4),
                  itemCount: imagenes.length,
                  itemBuilder: (context, int index) {
                    return ImgGaleria(
                      imgPath: imagenes[index],
                      onDelete: eliminarImagen,
                      editable: eventoEditable, // Pasa el valor de editable
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ImagePicker picker = ImagePicker();
          final XFile? image =
              await picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            await DB.subirFoto(image, widget.idEvento);
            setState(() {
              datos = DB.consguirEvento(widget.idEvento);
            });
          }
        },
        child: const Icon(Icons.add_a_photo),
      ),
      backgroundColor: Colores.crema,
    );
  }

  void eliminarImagen(String imgPath) {
    setState(() {
      datos = DB
          .eliminarFoto(imgPath, widget.idEvento)
          .then((_) => DB.consguirEvento(widget.idEvento));
    });
  }

  void mostrarConfirmacion(BuildContext context, String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('El evento ha sido $accion'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  //void toggleEditable() {
  // setState(() {
  //  widget.editable = !widget.editable;
  //});
  // }
}
