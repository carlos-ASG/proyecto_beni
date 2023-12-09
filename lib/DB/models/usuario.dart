class Usuario {
  String nombre;
  List invitaciones;
  List eventosPropios;

  Usuario({
    required this.nombre,
    required this.invitaciones,
    required this.eventosPropios,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      nombre: map["nombre"],
      invitaciones: map["invitaciones"],
      eventosPropios: map["eventosPropios"],
    );
  }

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "invitaciones": invitaciones,
        "eventosPropios": eventosPropios,
      };
}
