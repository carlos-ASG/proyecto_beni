import 'package:flutter/material.dart';
import 'package:meta/meta_meta.dart';
import 'package:proyecto_final/login.dart';
import 'package:proyecto_final/widgets/AlbumInv.dart';

Widget invitaciones(State<Login> puntero) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 100),
    child: ListView(children: [
      AlbumInv(
        imgPath: 'assets/foto.jpeg',
        descripcion: "des pruebaaaa",
        tituloGaleria: "galeria 1",
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
    ]),
  );
}
