import 'package:flutter/material.dart';
import 'package:meta/meta_meta.dart';
import 'package:proyecto_final/login.dart';
import 'package:proyecto_final/widgets/AlbumInv.dart';
import 'package:proyecto_final/widgets/Colores.dart';
import 'DB/serviciosRemotos.dart';

Widget invitaciones(
    State<Login> puntero, String idUsuario, BuildContext contextScaffold) {
  int indice = 0;

  switch (indice) {
    case 0:
      {
        return Column(
          children: [
            IconButton(
                onPressed: () {
                  puntero.setState(() {
                    indice = 1;
                  });
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
                              const SizedBox(width: 100),
                              AlbumInv(idEvento: idEventos[indice]),
                              const SizedBox(
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
    case 1:
      {
        final numeroEvento = TextEditingController();
        String busquedaEvento = "";
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 130,
                child: Column(
                  children: [
                    TextField(
                      controller: numeroEvento,
                      decoration: const InputDecoration(
                        labelText: "Numero del evento",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colores.azulOscuro,
                        foregroundColor: Colores.crema,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                      ),
                      child: const Text(
                        "Buscar evento",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Text(
                busquedaEvento,
                style: const TextStyle(fontSize: 20),
              )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colores.azulOscuro,
                            foregroundColor: Colores.crema,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7))),
                        child: const Text("Agregar evento")),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          indice = 0;
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colores.azulOscuro,
                            foregroundColor: Colores.crema,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7))),
                        child: const Text("Cancelar")),
                  ],
                ),
              )
            ],
          ),
        );
      }
  }
  return const Center();
}
