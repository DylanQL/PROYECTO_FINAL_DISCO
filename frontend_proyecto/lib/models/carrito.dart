import 'producto.dart';

class CarritoItem {
  final int id;
  final int productoId;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final Producto producto;

  CarritoItem({
    required this.id,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    required this.producto,
  });

  factory CarritoItem.fromJson(Map<String, dynamic> json) {
    return CarritoItem(
      id: json['id'],
      productoId: json['producto_id'],
      cantidad: json['cantidad'],
      precioUnitario: json['precio_unitario'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
      producto: Producto.fromJson(json['producto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto_id': productoId,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
      'subtotal': subtotal,
      'producto': producto.toJson(),
    };
  }
}

class CarritoItemCreate {
  final int productoId;
  final int cantidad;

  CarritoItemCreate({
    required this.productoId,
    required this.cantidad,
  });

  Map<String, dynamic> toJson() {
    return {
      'producto_id': productoId,
      'cantidad': cantidad,
    };
  }
}

class Carrito {
  final int id;
  final DateTime fechaCreacion;
  final DateTime? fechaActualizacion;
  final double total;
  final String estado;
  final List<CarritoItem> items;

  Carrito({
    required this.id,
    required this.fechaCreacion,
    this.fechaActualizacion,
    required this.total,
    required this.estado,
    required this.items,
  });

  factory Carrito.fromJson(Map<String, dynamic> json) {
    return Carrito(
      id: json['id'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fechaActualizacion: json['fecha_actualizacion'] != null
          ? DateTime.parse(json['fecha_actualizacion'])
          : null,
      total: json['total'].toDouble(),
      estado: json['estado'],
      items: (json['items'] as List)
          .map((item) => CarritoItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
      'total': total,
      'estado': estado,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
