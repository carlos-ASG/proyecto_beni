import 'package:flutter/material.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';

class ImgGaleria extends StatelessWidget {
  final String imgPath;
  final Function(String) onDelete;
  final bool editable;

  const ImgGaleria({
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
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
                      child:
                          Text('Cerrar', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        _mostrarConfirmacionBorrado(context);
                      },
                      child: Text('Eliminar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(
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
            title: Text('Confirmar eliminación'),
            content: Text('¿Estás seguro de que quieres eliminar esta imagen?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  onDelete(imgPath); // Elimina la imagen
                  Navigator.of(context)
                      .pop(); // Cierra el cuadro de diálogo de confirmación
                  Navigator.of(context)
                      .pop(); // Cierra el cuadro de diálogo de confirmación
                },
                child: Text('Eliminar'),
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
            title: Text('Sin permiso'),
            content: Text('No tienes permiso para eliminar esta imagen.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }
}
