import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';
import 'package:proyecto_final/widgets/Colores.dart';
import 'package:proyecto_final/widgets/imgGaleria.dart';

class GaleriaInv extends StatefulWidget {
  final String titulo;
  final String idEvento;

  const GaleriaInv({Key? key, required this.titulo, required this.idEvento})
      : super(key: key);

  @override
  _GaleriaInvState createState() => _GaleriaInvState();
}

class _GaleriaInvState extends State<GaleriaInv> {
  /*final imagenes = [
    "https://cdn.pixabay.com/photo/2016/02/10/21/59/landscape-1192669__340.jpg",
    "https://images.pexels.com/photos/1619317/pexels-photo-1619317.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
    "https://thumbs.dreamstime.com/b/paisajes-de-yosemite-46208063.jpg",
    "http://miracomohacerlo.com/wp-content/uploads/2016/10/Fotos-de-paisajes.jpg",
    "https://astelus.com/wp-content/viajes/Lago-Moraine-Parque-Nacional-Banff-Alberta-Canada.jpg",
    "https://us.123rf.com/450wm/kwasny221/kwasny2211910/kwasny221191001184/kwasny221191001184.jpg?ver=6",
    "https://www.nationalgeographic.com.es/medio/2018/02/27/playa-de-isuntza-lekeitio__1280x720.jpg",
    "https://fondosmil.com/fondo/2255.jpg",
    "https://cdn.pixabay.com/photo/2013/07/18/20/26/sea-164989__340.jpg",
    "https://static.dw.com/image/58845200_303.jpg",
    "https://i0.wp.com/blog.vivaaerobus.com/wp-content/uploads/2020/04/paisaje-de-los-cabos.jpg?resize=650%2C364&ssl=1",
    "https://media.istockphoto.com/id/471390160/es/foto/atitl%C3%A1n-guatemala.jpg?s=612x612&w=0&k=20&c=xbE9LJIGPiRIy6V1pjNrHpmWZVRlAcfhpF02cRdp-bs=",
    "https://elviajerofeliz.com/wp-content/uploads/2015/09/paisajes-de-Canada.jpg",
    "https://www.adondeviajar.es/wp-content/uploads/2022/05/mejores-paisajes-del-mundo-1024x538.jpg",
    "https://www.telesurtv.net/__export/1638504305316/sites/telesur/img/2021/12/02/p2.jpg",
    "https://www.blogdelfotografo.com/wp-content/uploads/2015/09/Paisaje-de-contrastes.jpg",
    "https://p4.wallpaperbetter.com/wallpaper/826/658/427/landscapes-nature-lakes-2560x1600-nature-lakes-hd-art-wallpaper-preview.jpg",
    "https://www.comprar-fotos.com/content/img/gal/615/dsc2633-arbol-sin-hojas-14720-times-9824-38-mb_2022020315010161fbee2d7556b.thumb.jpg",
    "https://viajerocasual.com/wp-content/uploads/2022/05/paisajes-de-canada-lago-louise.jpg",
  ];*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Colores.azulOscuro,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ))
        ],
      ),
      body: FutureBuilder(
          future: DB.consguirEvento(widget.idEvento),
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
                    return ImgGaleria(imgPath: imagenes[index]);
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
            DB.subirFoto(image, widget.idEvento);
          }
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colores.crema,
    );
  }
}
