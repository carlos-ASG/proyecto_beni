import 'package:flutter/material.dart';
import 'package:proyecto_final/agregarInvitacion.dart';
import 'package:proyecto_final/invitaciones.dart';
import 'package:proyecto_final/widgets/Colores.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String titulo = "Mis Eventos";
  final usuario = TextEditingController();
  final contra = TextEditingController();
  bool _logged = false;
  int _index = 0;
  Widget? floatingButton;

  Widget _item(String titulo, int indice) {
    return ListTile(
        onTap: () {
          setState(() {
            _index = indice;
          });
          Navigator.pop(context);
        },
        title: Text(
          titulo,
          style: const TextStyle(fontSize: 20),
        ));
  }

  Widget _body() {
    switch (_index) {
      case 0:
        {
          setState(() {
            titulo = "Mis eventos";
            floatingButton = null;
          });
          return Center();
        }
      case 1:
        {
          setState(() {
            floatingButton = FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AgregarInvitacion()));
              },
              child: const Icon(Icons.add),
            );
            titulo = "Invitaciones";
          });
          return invitaciones(this);
        }
    }
    return Center();
  }

  @override
  Widget build(BuildContext context) {
    return start();
  }

  Widget start() {
    if (!_logged) {
      return Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
            child: Column(
          children: [
            TextField(
              controller: usuario,
              decoration: const InputDecoration(labelText: "Usuario"),
            ),
            TextField(
              controller: contra,
              decoration: const InputDecoration(labelText: "contraseña"),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _logged = true;
                  });
                },
                child: const Text("Inisiar sesion")),
            ElevatedButton(onPressed: () {}, child: const Text("Registrarse")),
          ],
        )),
      ));
    } else {
      return Scaffold(
        backgroundColor: Colores.crema,
        appBar: AppBar(
          title: Text(titulo),
          backgroundColor: Colores.rosaOscuro,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              _item("Mis eventos", 0),
              _item("Invitaciones", 1),
              ListTile(
                title: const Text(
                  'Cerrar sesion',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  setState(() {
                    _logged = false;
                    _index = 0;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: _body(),
        floatingActionButton: floatingButton,
      );
    }
  }
}
