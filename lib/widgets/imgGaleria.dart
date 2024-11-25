import 'package:flutter/material.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';

class ImgGaleria extends StatelessWidget {
  final String imgPath;
  final Function(String) onDelete;
  final bool editable;

  const ImgGaleria({
    super.key,
    required this.imgPath,
    required this.onDelete,
    required this.editable,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DB.extrarImagen(imgPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.error != null) {
            return Image.asset('assets/error.jpeg');
          } else if (snapshot.data != null) {
            return GestureDetector(
              onTap: () {
                _mostrarDialogo(context, snapshot.data);
              },
              child: Image.network(
                snapshot.data,
                fit: BoxFit.cover,
              ),
            );
          }
          return Image.asset(
            'assets/error.jpeg',
            fit: BoxFit.cover,
          );
        }
      },
    );
  }

  void _mostrarDialogo(BuildContext context, String imgUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cerrar',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        _mostrarConfirmacionBorrado(context);
                      },
                      child: const Text('Eliminar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarConfirmacionBorrado(BuildContext context) {
    if (editable) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: const Text(
                '¿Estás seguro de que quieres eliminar esta imagen?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  onDelete(imgPath); // Elimina la imagen
                  Navigator.of(context)
                      .pop(); // Cierra el cuadro de diálogo de confirmación
                  Navigator.of(context)
                      .pop(); // Cierra el cuadro de diálogo de confirmación
                },
                child: const Text('Eliminar'),
              ),
            ],
          );
        },
      );
    } else {
      // Si no es editable, muestra un AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sin permiso'),
            content: const Text('No tienes permiso para eliminar esta imagen.'),
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
    }
  }
}
