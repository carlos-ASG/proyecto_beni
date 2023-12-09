import 'package:flutter/material.dart';
import 'package:meta/meta_meta.dart';
import 'package:proyecto_final/login.dart';
import 'package:proyecto_final/widgets/AlbumInv.dart';
import 'DB/serviciosRemotos.dart';

Widget invitaciones(State<Login> puntero, String idUsuario) {
  return FutureBuilder(
    future: DB.eventosInvitados(idUsuario),
    builder: (contex, listaEventos) {
      if (listaEventos.hasData) {
        return ListView.builder(
          itemCount: listaEventos.data?.length,
          itemBuilder: (context, indice) {
            return Row(
              children: [
                const SizedBox(
                  width: 100,
                ),
                AlbumInv(
                  imgPath: 'assets/foto.jpeg',
                  descripcion: listaEventos.data![indice].descripcion,
                ),
                const SizedBox(
                  width: 100,
                )
              ],
            );
          },
        );
      }
      return const Center(child: CircularProgressIndicator());
    },
  );
}
