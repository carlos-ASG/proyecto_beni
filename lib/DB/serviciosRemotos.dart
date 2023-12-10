import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_final/DB/models/eventos.dart';

var fireStore = FirebaseFirestore.instance;

class DB {
  static Future subirFoto(XFile image, String idEvento) async {
    //obtener la imagen y el nombre
    final File selectedImage = File(image.path);
    final String fileName = image.name;

    //intancia de Firebase Storage
    FirebaseStorage storage = FirebaseStorage.instance;
    //referencia de la imagen en Firebase Storage
    Reference ref = storage.ref().child(fileName);
    UploadTask uploadTask = ref.putFile(selectedImage);

    // Obtener la URL de la descarga
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageURL = await taskSnapshot.ref.getDownloadURL();

    return fireStore.collection('evento').doc(idEvento).update({
      'fotos': FieldValue.arrayUnion([fileName])
    });
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> conseguirUsuarios(
      String idusuario) async {
    return await fireStore.collection('usuario').doc(idusuario).get();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> consguirEvento(
      String idEvento) async {
    return await fireStore.collection('evento').doc(idEvento).get();
  }

  static Future extrarImagen(String nombreImg) async {
    return await FirebaseStorage.instance.ref(nombreImg).getDownloadURL();
  }
}
