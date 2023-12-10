import 'package:flutter/material.dart';
import 'package:proyecto_final/DB/serviciosRemotos.dart';

class ImgGaleria extends StatelessWidget {
  final String imgPath;

  const ImgGaleria({required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DB.extrarImagen(imgPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.error != null) {
            return Image.asset('assets/foto.jpeg');
          } else {
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
                SizedBox(height: 10,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey, // Cambia este color al que desees
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        );
      },
    );
  }
}
