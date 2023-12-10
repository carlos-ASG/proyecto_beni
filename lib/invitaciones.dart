import 'package:flutter/material.dart';
import 'package:meta/meta_meta.dart';
import 'package:proyecto_final/login.dart';
import 'package:proyecto_final/widgets/AlbumInv.dart';
import 'DB/serviciosRemotos.dart';

Widget invitaciones(State<Login> puntero, String idUsuario) {
  return FutureBuilder(
    future: DB.conseguirUsuarios(idUsuario),
    builder: (context, usuario) {
      if (usuario.hasData) {
        List idInvitaciones = usuario.data?['invitaciones'];
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: idInvitaciones.length,
          itemBuilder: (context, indice) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: AlbumInv(idEvento: idInvitaciones[indice]),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    FutureBuilder(
                      future: DB.consguirEvento(idInvitaciones[indice]),
                      builder: (context, evento) {
                        if (evento.hasData) {
                          String descripcion = evento.data?['descripcion'];
                          return Text(
                            descripcion,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          );
                        }
                        return Container(); // Puedes cambiar esto según tu lógica de carga.
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      return const Center(child: CircularProgressIndicator());
    },
  );
}

