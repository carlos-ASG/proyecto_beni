import 'package:flutter/material.dart';
import 'package:proyecto_final/misEventos.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o imagen
              /*Image.asset(
                'assets/futuristic_logo.png',
                height: 100,
              ),*/
              SizedBox(height: 32),
              // Usuario
              TextField(
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  prefixIcon:
                      Icon(Icons.person, color: Color(0xFF5F689F)), // #5f689f
                ),
              ),
              SizedBox(height: 16),
              // Contraseña
              TextField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon:
                      Icon(Icons.lock, color: Color(0xFF5F689F)), // #5f689f
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),
              FilledButton(
                onPressed: () {},
                child: const Text('Iniciar sesión'),
                color: Color(0xFFF59695), // #f59695
              ),

              SizedBox(height: 16),

              // Botón de registro
              TextButton(
                onPressed: () {
                  // Abre una hoja inferior de registro
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
                            // Aquí puedes agregar tu formulario de registro
                            // Puedes usar TextField, TextFormField, etc.
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Nombre',
                                prefixIcon: Icon(Icons.person,
                                    color: Color(0xFF5F689F)), // #5f689f
                              ),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Correo',
                                prefixIcon: Icon(Icons.email,
                                    color: Color(0xFF5F689F)), // #5f689f
                              ),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: Icon(Icons.lock,
                                    color: Color(0xFF5F689F)), // #5f689f
                              ),
                              obscureText: true,
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Lógica para registrar al usuario
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    primary: Color(0xFF5F689F), // #f59695
                                  ),
                                  child: Text('Registrar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    primary: Color(0xFF5F689F), // #5f689f
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
                  primary: Color(0xFFF59695), // #f59695
                ),
                child: Text('¿No estás registrado? Regístrate aquí'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;

  const FilledButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        primary: color,
      ),
    );
  }
}
