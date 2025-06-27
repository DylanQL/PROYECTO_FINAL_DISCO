import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carrito_provider.dart';
import '../widgets/carrito_item_widget.dart';
import 'carritos_history_screen.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CarritosHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CarritoProvider>(
        builder: (context, carritoProvider, child) {
          if (carritoProvider.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Agrega productos para comenzar',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: carritoProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = carritoProvider.items[index];
                    return CarritoItemWidget(item: item);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${carritoProvider.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              carritoProvider.limpiarCarrito();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Carrito limpiado'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Limpiar'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: carritoProvider.isLoading
                                ? null
                                : () => _registrarCarrito(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: carritoProvider.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text('Registrar Carrito'),
                          ),
                        ),
                      ],
                    ),
                    if (carritoProvider.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          carritoProvider.error!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _registrarCarrito(BuildContext context) async {
    final carritoProvider = Provider.of<CarritoProvider>(context, listen: false);
    
    final carrito = await carritoProvider.registrarCarrito();
    
    if (context.mounted) {
      if (carrito != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Carrito registrado exitosamente (ID: ${carrito.id})'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(carritoProvider.error ?? 'Error al registrar carrito'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
