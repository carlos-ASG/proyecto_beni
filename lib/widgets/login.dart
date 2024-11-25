import 'package:flutter/material.dart';
import 'package:proyecto_final/misEventos.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Logo o imagen
              /*Image.asset(
                'assets/futuristic_logo.png',
                height: 100,
              ),*/
              const SizedBox(height: 32),
              // Usuario
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  prefixIcon:
                      Icon(Icons.person, color: Color(0xFF5F689F)), // #5f689f
                ),
              ),
              const SizedBox(height: 16),
              // Contraseña
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon:
                      Icon(Icons.lock, color: Color(0xFF5F689F)), // #5f689f
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {},
                color: const Color(0xFFF59695),
                child: const Text('Iniciar sesión'), // #f59695
              ),

              const SizedBox(height: 16),

              // Botón de registro
              TextButton(
                onPressed: () {
                  // Abre una hoja inferior de registro
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: const Color(0xFFF59695),
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            const Text(
                              'Registro',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Aquí puedes agregar tu formulario de registro
                            // Puedes usar TextField, TextFormField, etc.
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Nombre',
                                prefixIcon: Icon(Icons.person,
                                    color: Color(0xFF5F689F)), // #5f689f
                              ),
                            ),
                            const SizedBox(height: 8),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Correo',
                                prefixIcon: Icon(Icons.email,
                                    color: Color(0xFF5F689F)), // #5f689f
                              ),
                            ),
                            const SizedBox(height: 8),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: Icon(Icons.lock,
                                    color: Color(0xFF5F689F)), // #5f689f
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Lógica para registrar al usuario
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Color(0xFF5F689F), // #f59695
                                  ),
                                  child: const Text('Registrar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Color(0xFF5F689F), // #5f689f
                                  ),
                                  child: const Text('Cancelar'),
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
                  foregroundColor: Color(0xFFF59695), // #f59695
                ),
                child: const Text('¿No estás registrado? Regístrate aquí'),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      child: child,
    );
  }
}
