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
                onTap: () {},
                child: Image.network(
                  snapshot.data,
                  fit: BoxFit.cover,
                ),
              );
            }
          }
        });
  }
}
