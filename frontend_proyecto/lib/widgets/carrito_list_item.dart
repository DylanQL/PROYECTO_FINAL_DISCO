import 'package:flutter/material.dart';
import '../models/carrito.dart';
import '../services/api_service.dart';
import 'carrito_detail_dialog.dart';

class CarritoListItem extends StatelessWidget {
  final Carrito carrito;

  const CarritoListItem({
    super.key,
    required this.carrito,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(),
          child: Text(
            '${carrito.id}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          'Carrito #${carrito.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fecha: ${_formatearFecha(carrito.fechaCreacion)}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Items: ${carrito.items.length} | Estado: ${carrito.estado}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${carrito.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, size: 20),
                  onPressed: () => _mostrarDetalle(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _eliminarCarrito(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _mostrarDetalle(context),
      ),
    );
  }

  Color _getStatusColor() {
    switch (carrito.estado.toLowerCase()) {
      case 'activo':
        return Colors.green;
      case 'completado':
        return Colors.blue;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year} '
           '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  void _mostrarDetalle(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CarritoDetailDialog(carrito: carrito),
    );
  }

  void _eliminarCarrito(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar carrito'),
          content: Text('¿Estás seguro de que deseas eliminar el carrito #${carrito.id}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _confirmarEliminacion(context);
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

  Future<void> _confirmarEliminacion(BuildContext context) async {
    try {
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await ApiService.eliminarCarrito(carrito.id);

      if (context.mounted) {
        Navigator.of(context).pop(); // Cerrar indicador de carga
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Carrito #${carrito.id} eliminado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Recargar la lista - esto podría manejarse mejor con state management
        // Por ahora, simplemente mostramos el mensaje
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Cerrar indicador de carga
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar carrito: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
