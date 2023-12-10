import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';
import 'package:proyecto_final/widgets/Colores.dart';
import 'package:proyecto_final/widgets/imgGaleria.dart';

class GaleriaPropios extends StatefulWidget {
  final String titulo;
  final String idEvento;

  const GaleriaPropios({Key? key, required this.titulo, required this.idEvento})
      : super(key: key);

  @override
  _GaleriaPropiosState createState() => _GaleriaPropiosState();
}

class _GaleriaPropiosState extends State<GaleriaPropios> {
  Future? datos;

  @override
  void initState() {
    super.initState();
    datos = DB.consguirEvento(
        widget.idEvento); // Reemplaza esto con tu función para obtener datos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Colores.azulOscuro,
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
                    return ImgGaleria(imgPath: imagenes[index],
                    onDelete: eliminarImagen,);
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
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colores.crema,
    );
  }

  void eliminarImagen(String imgPath) {
    setState(() {
      datos = DB.eliminarFoto(imgPath, widget.idEvento)
          .then((_) => DB.consguirEvento(widget.idEvento));
    });
  }
}
