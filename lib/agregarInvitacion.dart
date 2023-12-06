import 'package:flutter/material.dart';

class AgregarInvitacion extends StatefulWidget {
  const AgregarInvitacion({Key? key}) : super(key: key);

  @override
  _AgregarInvitacionState createState() => _AgregarInvitacionState();
}

class _AgregarInvitacionState extends State<AgregarInvitacion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar evento"),
      ),
    );
  }
}
