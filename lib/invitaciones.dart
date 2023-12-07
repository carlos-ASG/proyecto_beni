import 'package:flutter/material.dart';
import 'package:meta/meta_meta.dart';
import 'package:proyecto_final/login.dart';
import 'package:proyecto_final/widgets/AlbumInv.dart';

Widget invitaciones(State<Login> puntero) {
  return ListView(children: const [
    Row(
      children: [
        SizedBox(
          width: 100,
        ),
        AlbumInv(
          imgPath: 'assets/foto.jpeg',
          descripcion: "des pruebaaaaaaaaaaaaaaa\nq\na\na",
          tituloGaleria: "galeria 1",
        ),
        SizedBox(
          width: 100,
        )
      ],
    ),
    SizedBox(
      width: 10,
    ),
    AlbumInv(
      imgPath: 'assets/foto.jpeg',
      descripcion: "des pruebaaaaaaaaaa",
      tituloGaleria: "galeria 2",
    ),
    AlbumInv(
      imgPath: 'assets/foto.jpeg',
      descripcion: "des pruebaaaaaaaaaa",
      tituloGaleria: "galeria 3",
    )
  ]);
}
