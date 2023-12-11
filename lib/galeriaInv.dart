import 'package:flutter/material.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';
import 'package:proyecto_final/widgets/Colores.dart';
import 'package:proyecto_final/widgets/imgGaleria.dart';
import 'package:image_picker/image_picker.dart';

//gtduxGJZ
class GaleriaInv extends StatefulWidget {
  final String titulo;
  final String idEvento;
  final String idUsuario;

  const GaleriaInv(
      {Key? key,
      required this.titulo,
      required this.idEvento,
      required this.idUsuario})
      : super(key: key);

  @override
  _GaleriaInvState createState() => _GaleriaInvState();
}

class _GaleriaInvState extends State<GaleriaInv> {
  late bool eventoEditable;

  @override
  void initState() {
    super.initState();
    _checkEditableStatus();
  }

  Future<void> _checkEditableStatus() async {
    final evento = await DB.consguirEvento(widget.idEvento);
    setState(() {
      eventoEditable = evento['editable'] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Colores.azulOscuro,
      ),
      body: FutureBuilder(
        future: DB.consguirEvento(widget.idEvento),
        builder: (context, evento) {
          if (evento.hasData) {
            List imagenes = evento.data!['fotos'];
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150.0,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              padding: const EdgeInsets.all(4),
              itemCount: imagenes.length,
              itemBuilder: (context, int index) {
                return ImgGaleria(
                  imgPath: imagenes[index],
                  onDelete: (String imgPath) {
                    _eliminarImagen(imgPath);
                  },
                  editable: eventoEditable, // Pasa el valor de editable
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarAgregarImagen,
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarAgregarImagen() async {
    if (eventoEditable) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await DB.subirFoto(image, widget.idEvento);
        setState(() {
          _checkEditableStatus();
        });
      }
    } else {
      _mostrarAlerta();
    }
  }

  void _eliminarImagen(String imgPath) {
    setState(() {
      DB
          .eliminarFoto(imgPath, widget.idEvento)
          .then((_) => _checkEditableStatus());
    });
  }

  void _mostrarAlerta() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sin permiso'),
          content: Text('No tiene permiso para realizar esta acción.'),
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
