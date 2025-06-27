import 'package:flutter/material.dart';
import '../models/carrito.dart';

class CarritoDetailDialog extends StatelessWidget {
  final Carrito carrito;

  const CarritoDetailDialog({
    super.key,
    required this.carrito,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 600,
        ),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Carrito #${carrito.id}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fecha: ${_formatearFecha(carrito.fechaCreacion)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Estado: ${carrito.estado}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Lista de items
            Expanded(
              child: carrito.items.isEmpty
                  ? const Center(
                      child: Text('No hay items en este carrito'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: carrito.items.length,
                      itemBuilder: (context, index) {
                        final item = carrito.items[index];
                        return _buildItemCard(item);
                      },
                    ),
            ),
            
            // Footer con total
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total de items: ${carrito.items.length}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Total: \$${carrito.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cerrar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(CarritoItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen del producto
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: item.producto.imagenUrl != null && item.producto.imagenUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
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
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  if (item.producto.categoria != null)
                    Text(
                      item.producto.categoria!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${item.precioUnitario.toStringAsFixed(2)} c/u',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            
            // Cantidad y subtotal
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Cantidad: ${item.cantidad}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
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
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
        child: Icon(
          Icons.inventory_2_outlined,
          size: 20,
          color: Colors.grey,
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year} '
           '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}
