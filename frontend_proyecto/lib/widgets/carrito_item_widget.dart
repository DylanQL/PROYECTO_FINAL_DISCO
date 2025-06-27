import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carrito_provider.dart';

class CarritoItemWidget extends StatelessWidget {
  final CarritoItemLocal item;

  const CarritoItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen del producto
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.producto.imagenUrl != null && item.producto.imagenUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.producto.imagenUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      ),
                    )
                  : _buildPlaceholderImage(),
            ),
            const SizedBox(width: 12),
            
            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.producto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (item.producto.categoria != null)
                    Text(
                      item.producto.categoria!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.producto.precio.toStringAsFixed(2)} c/u',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            
            // Controles de cantidad
            Column(
              children: [
                Consumer<CarritoProvider>(
                  builder: (context, carritoProvider, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (item.cantidad > 1) {
                              carritoProvider.actualizarCantidad(
                                item.producto.id,
                                item.cantidad - 1,
                              );
                            } else {
                              _mostrarDialogoEliminar(context, carritoProvider);
                            }
                          },
                          icon: Icon(
                            item.cantidad > 1 ? Icons.remove : Icons.delete,
                            color: item.cantidad > 1 ? Colors.grey[700] : Colors.red,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${item.cantidad}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: item.cantidad < item.producto.stock
                              ? () {
                                  carritoProvider.actualizarCantidad(
                                    item.producto.id,
                                    item.cantidad + 1,
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.add),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${item.subtotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.inventory_2_outlined,
          size: 24,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _mostrarDialogoEliminar(BuildContext context, CarritoProvider carritoProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar producto'),
          content: Text('¿Estás seguro de que deseas eliminar "${item.producto.nombre}" del carrito?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                carritoProvider.eliminarProducto(item.producto.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.producto.nombre} eliminado del carrito'),
                  ),
                );
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
