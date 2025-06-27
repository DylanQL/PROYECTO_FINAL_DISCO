import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/producto.dart';
import '../providers/carrito_provider.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;

  const ProductoCard({
    super.key,
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              child: producto.imagenUrl != null && producto.imagenUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      child: Image.network(
                        producto.imagenUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      ),
                    )
                  : _buildPlaceholderImage(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (producto.categoria != null)
                    Text(
                      producto.categoria!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${producto.precio.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        'Stock: ${producto.stock}',
                        style: TextStyle(
                          fontSize: 12,
                          color: producto.stock > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Consumer<CarritoProvider>(
                builder: (context, carritoProvider, child) {
                  final cantidadEnCarrito = carritoProvider.getCantidadProducto(producto.id);
                  
                  if (cantidadEnCarrito > 0) {
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: producto.stock > 0
                                ? () => _mostrarDialogoCantidad(context, carritoProvider)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: Text('En carrito ($cantidadEnCarrito)'),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: producto.stock > 0
                          ? () => _agregarAlCarrito(context, carritoProvider)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: producto.stock > 0
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text(
                        producto.stock > 0 ? 'Agregar' : 'Sin Stock',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(4),
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.inventory_2_outlined,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _agregarAlCarrito(BuildContext context, CarritoProvider carritoProvider) {
    carritoProvider.agregarProducto(producto, 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${producto.nombre} agregado al carrito'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Ver carrito',
          onPressed: () {
            // Navegar al carrito - esto se puede implementar según la estructura de navegación
          },
        ),
      ),
    );
  }

  void _mostrarDialogoCantidad(BuildContext context, CarritoProvider carritoProvider) {
    int cantidadActual = carritoProvider.getCantidadProducto(producto.id);
    int nuevaCantidad = cantidadActual;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(producto.nombre),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Selecciona la cantidad:'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: nuevaCantidad > 0
                            ? () {
                                setState(() {
                                  nuevaCantidad--;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$nuevaCantidad',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        onPressed: nuevaCantidad < producto.stock
                            ? () {
                                setState(() {
                                  nuevaCantidad++;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stock disponible: ${producto.stock}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                if (nuevaCantidad == 0)
                  TextButton(
                    onPressed: () {
                      carritoProvider.eliminarProducto(producto.id);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${producto.nombre} eliminado del carrito'),
                        ),
                      );
                    },
                    child: const Text('Eliminar'),
                  ),
                TextButton(
                  onPressed: () {
                    if (nuevaCantidad > 0) {
                      carritoProvider.actualizarCantidad(producto.id, nuevaCantidad);
                    } else {
                      carritoProvider.eliminarProducto(producto.id);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Actualizar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
