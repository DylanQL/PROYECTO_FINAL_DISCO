import 'package:flutter/material.dart';
import '../models/carrito.dart';
import '../services/api_service.dart';
import '../widgets/carrito_list_item.dart';

class CarritosHistoryScreen extends StatefulWidget {
  const CarritosHistoryScreen({super.key});

  @override
  State<CarritosHistoryScreen> createState() => _CarritosHistoryScreenState();
}

class _CarritosHistoryScreenState extends State<CarritosHistoryScreen> {
  List<Carrito> carritos = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _cargarCarritos();
  }

  Future<void> _cargarCarritos() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      print('Cargando carritos...'); // Debug
      final carritosResponse = await ApiService.getCarritos().timeout(
        const Duration(seconds: 10),
      );
      print('Carritos cargados: ${carritosResponse.length}'); // Debug
      
      setState(() {
        carritos = carritosResponse;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar carritos: $e'); // Debug
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Carritos'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar carritos',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _cargarCarritos,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : carritos.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text('No hay carritos registrados'),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _cargarCarritos,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: carritos.length,
                        itemBuilder: (context, index) {
                          return CarritoListItem(
                            carrito: carritos[index],
                            onDeleted: _cargarCarritos, // Recargar lista cuando se elimine
                          );
                        },
                      ),
                    ),
    );
  }
}
