import 'package:flutter/material.dart';
import 'package:proyecto_final/agregarInvitacion.dart';
import 'package:proyecto_final/invitaciones.dart';
import 'package:proyecto_final/misEventos.dart';
import 'package:proyecto_final/widgets/Colores.dart';
import 'package:proyecto_final/widgets/FilledButton.dart';
import 'AuthServices.dart';
import '/DB/serviciosRemotos.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String titulo = "Mis Eventos";
  final emailController = TextEditingController();
  final contraController = TextEditingController();
  final nombreController = TextEditingController();
  bool _logged = false;
  int _index = 0;
  Widget? floatingButton;
  String idUsuario = "";

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _item(String title, int indice) {
    return ListTile(
      onTap: () {
        setState(() {
          _index = indice;
          if (indice == 0) {
            titulo = "Mis eventos";
          }
          if (indice == 1) {
            titulo = "Invitaciones";
          }
        });
        Navigator.pop(context);
      },
      title: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _body() {
    switch (_index) {
      case 0:
        {
          setState(() {
            titulo = "Mis eventos";
            floatingButton = null;
          });
          return misEventos(this, idUsuario);
        }
      case 1:
        {
          setState(() {
            titulo = "Invitaciones";
            floatingButton = FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AgregarInvitacion()));
              },
              child: const Icon(Icons.add),
            );
          });
          return invitaciones(this, idUsuario);
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
      idUsuario = "";
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Bienvenido'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    prefixIcon: Icon(Icons.person, color: Color(0xFF5F689F)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contraController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF5F689F)),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                FilltedButton(
                  onPressed: () async {
                    bool loginSuccess = await AuthServices.iniciarSesion(
                      emailController.text,
                      contraController.text,
                    );

                    if (loginSuccess) {
                      setState(() {
                        _logged = true;

                      });
                    } else {
                      _mostrarSnackBar(
                          'Inicio de sesión fallido. Verifica tus credenciales.');
                    }
                  },
                  color: const Color(0xFFF59695),
                  child: const Text('Iniciar sesión'),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Color(0xFFF59695),
                      builder: (BuildContext context) {
                        return Container(
                          padding: EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Text(
                                'Registro',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: nombreController,
                                decoration: InputDecoration(
                                  labelText: 'Nombre',
                                  prefixIcon: Icon(Icons.person,
                                      color: Color(0xFF5F689F)),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Correo',
                                  prefixIcon: Icon(Icons.email,
                                      color: Color(0xFF5F689F)),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: contraController,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: Icon(Icons.lock,
                                      color: Color(0xFF5F689F)),
                                ),
                                obscureText: true,
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      bool registrationSuccess =
                                      await AuthServices.registrarUsuario(
                                        nombreController.text,
                                        emailController.text,
                                        contraController.text,
                                      );

                                      if (registrationSuccess) {
                                        Navigator.of(context).pop();
                                      } else {
                                        _mostrarSnackBar(
                                            'Registro fallido. Verifica tus datos.');
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Color(0xFF5F689F),
                                    ),
                                    child: Text('Registrar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Color(0xFF5F689F),
                                    ),
                                    child: Text('Cancelar'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    primary: Color(0xFFF59695),
                  ),
                  child: Text('¿No estás registrado? Regístrate aquí'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      idUsuario = "04nQfaAwq7UJnlzPgviL";
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

  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }
}