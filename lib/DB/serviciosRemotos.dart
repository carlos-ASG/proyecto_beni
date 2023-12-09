import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_final/DB/models/eventos.dart';

var fireStore = FirebaseFirestore.instance;

class DB {
  static Future subirFoto(XFile image) {
    final File file = File(image.path);
    return Future(() => null);
  }

  static Future<List<Evento>> eventosInvitados(String idusuario) async {
    List<Evento> eventos = [];

    await fireStore.collection('usuario').doc(idusuario).get().then((value) {
      Map<String, dynamic> usuario = value.data() as Map<String, dynamic>;
      List idEventos =
          usuario['invitaciones'].map((id) => id.toString()).toList();
      for (var idEvento in idEventos) {
        fireStore.collection('evento').doc(idEvento).get().then((value) {
          Map<String, dynamic> map = value.data() as Map<String, dynamic>;
          eventos.add(Evento.fromMap(map));
        });
      }
    });

    return eventos;
  }
}
