import 'package:flutter/foundation.dart';
import '../models/producto.dart';
import '../models/carrito.dart';
import '../services/api_service.dart';

class CarritoProvider with ChangeNotifier {
  List<CarritoItemLocal> _items = [];
  bool _isLoading = false;
  String? _error;

  List<CarritoItemLocal> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get total {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.cantidad);
  }

  /// Agregar producto al carrito local
  void agregarProducto(Producto producto, int cantidad) {
    final existingIndex = _items.indexWhere((item) => item.producto.id == producto.id);

    if (existingIndex >= 0) {
      // Si el producto ya existe, actualizar cantidad
      _items[existingIndex] = CarritoItemLocal(
        producto: producto,
        cantidad: _items[existingIndex].cantidad + cantidad,
      );
    } else {
      // Si no existe, agregar nuevo item
      _items.add(CarritoItemLocal(
        producto: producto,
        cantidad: cantidad,
      ));
    }

    notifyListeners();
  }

  /// Actualizar cantidad de un producto
  void actualizarCantidad(int productoId, int nuevaCantidad) {
    if (nuevaCantidad <= 0) {
      eliminarProducto(productoId);
      return;
    }

    final index = _items.indexWhere((item) => item.producto.id == productoId);
    if (index >= 0) {
      _items[index] = CarritoItemLocal(
        producto: _items[index].producto,
        cantidad: nuevaCantidad,
      );
      notifyListeners();
    }
  }

  /// Eliminar producto del carrito
  void eliminarProducto(int productoId) {
    _items.removeWhere((item) => item.producto.id == productoId);
    notifyListeners();
  }

  /// Limpiar carrito
  void limpiarCarrito() {
    _items.clear();
    notifyListeners();
  }

  /// Registrar carrito en el servidor
  Future<Carrito?> registrarCarrito() async {
    if (_items.isEmpty) {
      _error = 'El carrito está vacío';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final itemsApi = _items.map((item) => CarritoItemCreate(
        productoId: item.producto.id,
        cantidad: item.cantidad,
      )).toList();

      final carrito = await ApiService.crearCarrito(itemsApi);
      
      // Limpiar carrito local después del registro exitoso
      _items.clear();
      
      _isLoading = false;
      notifyListeners();
      
      return carrito;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Verificar si un producto está en el carrito
  bool contieneProducto(int productoId) {
    return _items.any((item) => item.producto.id == productoId);
  }

  /// Obtener cantidad de un producto en el carrito
  int getCantidadProducto(int productoId) {
    final item = _items.firstWhere(
      (item) => item.producto.id == productoId,
      orElse: () => CarritoItemLocal(
        producto: Producto(
          id: -1,
          nombre: '',
          precio: 0,
          stock: 0,
          fechaCreacion: DateTime.now(),
        ),
        cantidad: 0,
      ),
    );
    return item.cantidad;
  }
}

/// Clase para manejar items del carrito localmente
class CarritoItemLocal {
  final Producto producto;
  final int cantidad;

  CarritoItemLocal({
    required this.producto,
    required this.cantidad,
  });

  double get subtotal => producto.precio * cantidad;
}
