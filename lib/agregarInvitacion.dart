import 'package:flutter/material.dart';
import 'package:proyecto_final/widgets/Colores.dart';

class AgregarInvitacion extends StatefulWidget {
  const AgregarInvitacion({Key? key}) : super(key: key);

  @override
  _AgregarInvitacionState createState() => _AgregarInvitacionState();
}

class _AgregarInvitacionState extends State<AgregarInvitacion> {
  final numeroEvento = TextEditingController();
  String busquedaEvento = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar evento"),
        backgroundColor: Colores.rosaOscuro,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
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
            )
          ],
        ),
      ),
    );
  }
}
