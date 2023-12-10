import 'package:cloud_firestore/cloud_firestore.dart';

var fireStore = FirebaseFirestore.instance;

class AuthServices {
  static Future<bool> registrarUsuario(String nombre, String email, String contra) async {
    try {
      // Verificar si el email ya está en uso
      QuerySnapshot<Map<String, dynamic>> existingUser = await fireStore
          .collection('usuario')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        // El email ya está en uso
        print('Error: El email ya está registrado');
        return false; // Registro fallido
      }

      // Registrar el usuario en la colección 'usuario'
      await fireStore.collection('usuario').add({
        'nombre': nombre,
        'email': email,
        'contra': contra,
      });

      return true; // Registro exitoso
    } catch (e) {
      print('Error al registrar usuario: $e');
      return false; // Registro fallido
    }
  }

  static Future<bool> iniciarSesion(String email, String contra) async {
    try {
      // Consultar la colección 'usuario' para obtener las credenciales del usuario
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await fireStore
          .collection('usuario')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Verificar las credenciales del usuario
        String storedPassword = querySnapshot.docs.first['contra'];
        if (storedPassword == contra) {
          return true; // Inicio de sesión exitoso
        }
      }
      return false; // Inicio de sesión fallido
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return false; // Inicio de sesión fallido
    }
  }
}

