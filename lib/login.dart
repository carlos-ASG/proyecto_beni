import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/agregarInvitacion.dart';
import 'package:proyecto_final/misEventos.dart';
import 'package:proyecto_final/widgets/AlbumInv.dart';
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
  String idUsuario = "";
  String busquedaEvento = "";
  bool _eventoEncontrado = false;
  String numero_evento = "";
  String idEvento = "";

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
        ));
  }

  Widget _body() {
    switch (_index) {
      case 0:
        {
          setState(() {
            titulo = "Mis eventos";
          });
          return misEventos(this, idUsuario);
        }
      case 1:
        {
          setState(() {
            titulo = "Invitaciones";
          });
          return invitaciones();
        }

      case 2:
        {
          setState(() {
            titulo = "Agregar Evento";
          });
          return agregarInvitacion();
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
                      AuthServices.conseguirIdUsuario(emailController.text)
                          .then((value) {
                        var docs = value.docs;
                        for (var doc in docs) {
                          idUsuario = doc.id;
                        }
                        if (idUsuario != "") {
                          setState(() {
                            _logged = true;
                          });
                        } else {
                          _mostrarSnackBar("fallo al inciar sesion");
                        }
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
                      isScrollControlled: true,
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
                  color: Color.fromARGB(255, 95, 104, 159),
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

  Widget invitaciones() {
    return Column(
      children: [
        IconButton(
            onPressed: () {
              setState(() {
                _index = 2;
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
                          AlbumInv(
                              idEvento: idEventos[indice],
                              idUsuario: idUsuario),
                          const SizedBox(
                            width: 100,
                          )
                        ],
                      );
                    });
              }else{
                return Text("Aún no hay invitaciones");
              }
              return const Center(child: CircularProgressIndicator());
              return Text("Aún no hay invitaciones");
            },
          ),
        ),
      ],
    );
  }

  Widget agregarInvitacion() {
    final numeroEvento = TextEditingController();

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
                  onPressed: () {
                    numero_evento = numeroEvento.text;
                    Future<List> eventos = DB.buscarInvitacion(numero_evento);
                    eventos.then((value) {
                      setState(() {
                        if (value.isEmpty) {
                          setState(() {
                            busquedaEvento = "El evento que busca no existe";
                          });
                        } else {
                          DB
                              .conseguirUsuarios(value[0]['idusuario'])
                              .then((usuario) {
                            setState(() {
                              busquedaEvento =
                                  "Propietario: ${usuario.data()?['nombre']}\n" +
                                      "Descripcion: ${value[0]['descripcion']}\n" +
                                      "Fecha de inicio: ${value[0]['fecha_ini'].toDate().toIso8601String().substring(0, 10)}\n" +
                                      "Fecha de fin: ${value[0]['fecha_fin'].toDate().toIso8601String().substring(0, 10)}\n";
                              _eventoEncontrado = true;
                              idEvento = value[0]['id'];
                            });
                          });
                        }
                      });
                    });
                  },
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
                    onPressed: () {
                      if (numero_evento != "") {
                        DB.agregarInvitacion(idUsuario, idEvento).then((value) {
                          setState(() {
                            busquedaEvento = "Evento agregado";
                            _eventoEncontrado = false;
                            numero_evento = "";
                            idEvento = "";
                          });
                        });
                      }
                    },
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
                      setState(() {
                        _index = 1;
                        busquedaEvento = "";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colores.azulOscuro,
                        foregroundColor: Colores.crema,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))),
                    child: const Text("Salir")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
