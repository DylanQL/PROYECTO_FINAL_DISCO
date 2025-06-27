import 'package:flutter/material.dart';
import '../models/carrito.dart';
import '../services/api_service.dart';
import 'carrito_detail_dialog.dart';

class CarritoListItem extends StatelessWidget {
  final Carrito carrito;
  final VoidCallback? onDeleted; // Callback para notificar eliminación

  const CarritoListItem({
    super.key,
    required this.carrito,
    this.onDeleted,
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
    print('Iniciando eliminación del carrito ${carrito.id}'); // Debug
    
    // Usar una variable para controlar el estado del diálogo
    bool isDialogShowing = false;
    
    try {
      // Mostrar indicador de carga
      isDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Expanded(child: Text('Eliminando carrito...')),
            ],
          ),
        ),
      );

      print('Llamando a ApiService.eliminarCarrito(${carrito.id})'); // Debug
      await ApiService.eliminarCarrito(carrito.id);
      print('Carrito eliminado exitosamente'); // Debug

      // Cerrar diálogo INMEDIATAMENTE después del éxito
      if (isDialogShowing && context.mounted) {
        Navigator.of(context).pop();
        isDialogShowing = false;
        print('Diálogo cerrado tras éxito'); // Debug
      }

      // Esperar un poco antes de mostrar el mensaje de éxito
      await Future.delayed(const Duration(milliseconds: 100));

      // Mostrar mensaje de éxito
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Carrito #${carrito.id} eliminado exitosamente'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Notificar al padre que se eliminó el carrito
        if (onDeleted != null) {
          print('Ejecutando callback onDeleted'); // Debug
          onDeleted!();
        }
      }
      
    } catch (e) {
      print('Error al eliminar carrito: $e'); // Debug
      
      // Cerrar diálogo INMEDIATAMENTE en caso de error
      if (isDialogShowing && context.mounted) {
        Navigator.of(context).pop();
        isDialogShowing = false;
        print('Diálogo cerrado tras error'); // Debug
      }

      // Esperar un poco antes de mostrar el error
      await Future.delayed(const Duration(milliseconds: 100));

      // Mostrar mensaje de error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar carrito: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
        
        // También mostrar un diálogo de error para debugging
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error de conexión'),
            content: Text('No se pudo eliminar el carrito.\n\nError: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      // Asegurar que el diálogo se cierre en cualquier caso
      if (isDialogShowing && context.mounted) {
        try {
          Navigator.of(context).pop();
          print('Diálogo cerrado en finally'); // Debug
        } catch (e) {
          print('Error cerrando diálogo en finally: $e'); // Debug
        }
      }
    }
  }
}
