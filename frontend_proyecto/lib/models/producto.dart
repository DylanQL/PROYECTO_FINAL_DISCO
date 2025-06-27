class Producto {
  final int id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int stock;
  final String? imagenUrl;
  final String? categoria;
  final DateTime fechaCreacion;
  final DateTime? fechaActualizacion;

  Producto({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.stock,
    this.imagenUrl,
    this.categoria,
    required this.fechaCreacion,
    this.fechaActualizacion,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: json['precio'].toDouble(),
      stock: json['stock'],
      imagenUrl: json['imagen_url'],
      categoria: json['categoria'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fechaActualizacion: json['fecha_actualizacion'] != null
          ? DateTime.parse(json['fecha_actualizacion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'imagen_url': imagenUrl,
      'categoria': categoria,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
    };
  }
}
