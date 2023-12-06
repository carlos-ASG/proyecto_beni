import 'package:flutter/material.dart';

class GaleriaInv extends StatefulWidget {
  final String titulo;

  const GaleriaInv({Key? key, required this.titulo}) : super(key: key);

  @override
  _GaleriaInvState createState() => _GaleriaInvState();
}

class _GaleriaInvState extends State<GaleriaInv> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
      ),
    );
  }
}
