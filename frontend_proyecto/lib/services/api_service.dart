import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';
import '../models/carrito.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.56.1:8000';

  // Headers comunes
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // ==================== PRODUCTOS ====================

  /// Obtener lista de productos
  static Future<List<Producto>> getProductos({int skip = 0, int limit = 100}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/productos?skip=$skip&limit=$limit'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> productosJson = data['productos'];
        return productosJson.map((json) => Producto.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar productos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener un producto por ID
  static Future<Producto> getProducto(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/productos/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Producto.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Producto no encontrado');
      }
    } catch (e) {
      throw Exception('Error al cargar producto: $e');
    }
  }

  // ==================== CARRITO ====================

  /// Obtener lista de carritos
  static Future<List<Carrito>> getCarritos({int skip = 0, int limit = 100}) async {
    try {
      print('Obteniendo carritos: $baseUrl/carrito?skip=$skip&limit=$limit'); // Debug
      
      final response = await http.get(
        Uri.parse('$baseUrl/carrito?skip=$skip&limit=$limit'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      print('Response status getCarritos: ${response.statusCode}'); // Debug

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> carritosJson = data['carritos'];
        print('Número de carritos recibidos: ${carritosJson.length}'); // Debug
        return carritosJson.map((json) => Carrito.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar carritos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getCarritos: $e'); // Debug
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener un carrito por ID
  static Future<Carrito> getCarrito(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/carrito/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Carrito.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Carrito no encontrado');
      }
    } catch (e) {
      throw Exception('Error al cargar carrito: $e');
    }
  }

  /// Crear un nuevo carrito
  static Future<Carrito> crearCarrito(List<CarritoItemCreate> items) async {
    try {
      final body = jsonEncode({
        'items': items.map((item) => item.toJson()).toList(),
      });

      final response = await http.post(
        Uri.parse('$baseUrl/carrito/'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Carrito.fromJson(data['carrito']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al crear carrito');
      }
    } catch (e) {
      throw Exception('Error al crear carrito: $e');
    }
  }

  /// Actualizar un carrito
  static Future<Carrito> actualizarCarrito(int id, List<CarritoItemCreate> items) async {
    try {
      final body = jsonEncode({
        'items': items.map((item) => item.toJson()).toList(),
      });

      final response = await http.put(
        Uri.parse('$baseUrl/carrito/$id'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Carrito.fromJson(data['carrito']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al actualizar carrito');
      }
    } catch (e) {
      throw Exception('Error al actualizar carrito: $e');
    }
  }

  /// Eliminar un carrito
  static Future<void> eliminarCarrito(int id) async {
    try {
      print('Eliminando carrito ID: $id'); // Debug
      print('URL: $baseUrl/carrito/$id'); // Debug
      
      final response = await http.delete(
        Uri.parse('$baseUrl/carrito/$id'),
        headers: headers,
      ).timeout(
        const Duration(seconds: 15), // Timeout más largo
        onTimeout: () {
          throw Exception('Timeout: La eliminación está tomando demasiado tiempo');
        },
      );

      print('Response status: ${response.statusCode}'); // Debug
      print('Response body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        print('Carrito eliminado exitosamente del servidor'); // Debug
        return; // Éxito
      } else if (response.statusCode == 404) {
        throw Exception('El carrito no existe o ya fue eliminado');
      } else {
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Error del servidor: ${response.statusCode}');
        } catch (jsonError) {
          throw Exception('Error del servidor: ${response.statusCode} - ${response.body}');
        }
      }
    } on http.ClientException catch (e) {
      print('Error de conexión HTTP: $e'); // Debug
      throw Exception('Error de conexión: No se pudo conectar al servidor');
    } on FormatException catch (e) {
      print('Error de formato JSON: $e'); // Debug
      throw Exception('Error de respuesta del servidor');
    } catch (e) {
      print('Error general en eliminarCarrito: $e'); // Debug
      if (e.toString().contains('Timeout')) {
        throw Exception('La eliminación está tomando demasiado tiempo. Verifica tu conexión.');
      }
      throw Exception('Error al eliminar carrito: $e');
    }
  }

  /// Verificar conectividad con la API
  static Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: headers,
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
