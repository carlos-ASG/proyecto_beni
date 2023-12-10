import 'package:flutter/material.dart';
import 'package:meta/meta_meta.dart';
import 'package:proyecto_final/login.dart';
import 'package:proyecto_final/widgets/AlbumInv.dart';
import 'DB/serviciosRemotos.dart';

Widget invitaciones(
    State<Login> puntero, String idUsuario, BuildContext contextScaffold) {
  return Column(
    children: [
      IconButton(
          onPressed: () {
            String resultado = "";
            showBottomSheet(
              context: contextScaffold,
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(),
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Buscar evento")),
                    Text(resultado),
                    ElevatedButton(
                        onPressed: () {}, child: Text("Agregar Evento"))
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.add)),
      Expanded(
        child: FutureBuilder(
          future: DB.conseguirUsuarios(idUsuario),
          builder: (contex, usuario) {
            if (usuario.hasData) {
              List idEventos = usuario.data?['invitaciones'];
              return ListView.builder(
                  itemCount: idEventos.length,
                  itemBuilder: (context, indice) {
                    return Row(
                      children: [
                        SizedBox(width: 100),
                        AlbumInv(idEvento: idEventos[indice]),
                        SizedBox(
                          width: 100,
                        )
                      ],
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    ],
  );
}
