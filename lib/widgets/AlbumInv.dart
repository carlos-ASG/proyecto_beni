import 'package:flutter/material.dart';
import 'package:proyecto_final/galeriaInv.dart';
import 'package:proyecto_final/widgets/Colores.dart';

class AlbumInv extends StatelessWidget {
  final String imgPath;
  final String descripcion;
  final String tituloGaleria;

  const AlbumInv(
      {super.key,
      required this.imgPath,
      required this.descripcion,
      required this.tituloGaleria});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(5),
          height: 240,
          width: 5,
          decoration: BoxDecoration(
            color: Colores.azulClaro,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GaleriaInv(titulo: tituloGaleria)));
                },
                child: Image.asset(
                  imgPath,
                  width: 130,
                ),
              ),
              Text(
                descripcion,
                style: const TextStyle(fontSize: 15),
              )
            ],
          )),
    );
  }
}
