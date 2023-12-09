import 'package:cloud_firestore/cloud_firestore.dart';

class Evento {
  String descripcion;
  bool editable;
  Timestamp fechaIni;
  Timestamp fechaFin;
  List fotos;
  String numeroEvento;

  Evento({
    required this.descripcion,
    required this.editable,
    required this.fechaIni,
    required this.fechaFin,
    required this.fotos,
    required this.numeroEvento,
  });

  factory Evento.fromMap(Map<String, dynamic> map) {
    return Evento(
      descripcion: map["descripcion"],
      editable: map["editable"],
      fechaIni: map["fecha_ini"],
      fechaFin: map["fecha_fin"],
      fotos: map["fotos"],
      numeroEvento: map["numero_evento"],
    );
  }

  Map<String, dynamic> toJson() => {
        "descripcion": descripcion,
        "editable": editable,
        "fecha_ini": fechaIni,
        "fecha_fin": fechaFin,
        "fotos": fotos,
        "numero_evento": numeroEvento,
      };
}
