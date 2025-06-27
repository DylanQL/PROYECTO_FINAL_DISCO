# Frontend Flutter - Tienda Online

Aplicación móvil desarrollada en Flutter que consume la API REST de la tienda online.

## 🚀 Características

- **Visualización de productos**: Lista de productos con información detallada
- **Carrito de compras**: Agregar, editar y eliminar productos del carrito
- **Gestión de cantidades**: Controlar la cantidad de productos en el carrito
- **Registro de carritos**: Enviar carrito al servidor para su procesamiento
- **Historial de carritos**: Ver carritos registrados anteriormente
- **Interfaz moderna**: UI responsiva y atractiva

## 📱 Pantallas

### 1. **Productos Screen**
- Lista de productos en formato grid
- Información de cada producto (nombre, precio, stock, categoría)
- Botón para agregar al carrito
- Indicador de productos en el carrito
- Búsqueda y filtrado (futuro)

### 2. **Carrito Screen**
- Lista de productos en el carrito
- Controles para modificar cantidades
- Cálculo automático del total
- Botones para limpiar carrito y registrar compra

### 3. **Historial de Carritos Screen**
- Lista de carritos registrados
- Información de fecha, total y estado
- Opción para ver detalles de cada carrito
- Funcionalidad para eliminar carritos

## 🛠️ Configuración y Instalación

### Prerrequisitos
- Flutter SDK (>=3.7.2)
- Dart SDK
- Android Studio / VS Code
- Dispositivo Android/iOS o emulador

### Instalación

1. **Navegar al directorio del proyecto:**
```bash
cd frontend_proyecto
```

2. **Instalar dependencias:**
```bash
flutter pub get
```

3. **Verificar configuración de Flutter:**
```bash
flutter doctor
```

4. **Ejecutar la aplicación:**
```bash
flutter run
```

## 📦 Dependencias

- `flutter`: SDK principal
- `http`: Cliente HTTP para consumir la API
- `provider`: Manejo de estado
- `cached_network_image`: Carga y cache de imágenes
- `cupertino_icons`: Iconos iOS

## 🏗️ Arquitectura del Proyecto

```
lib/
├── main.dart                   # Punto de entrada de la aplicación
├── models/                     # Modelos de datos
│   ├── producto.dart
│   └── carrito.dart
├── services/                   # Servicios para comunicación con API
│   └── api_service.dart
├── providers/                  # Providers para manejo de estado
│   └── carrito_provider.dart
├── screens/                    # Pantallas de la aplicación
│   ├── productos_screen.dart
│   ├── carrito_screen.dart
│   └── carritos_history_screen.dart
└── widgets/                    # Widgets reutilizables
    ├── producto_card.dart
    ├── carrito_item_widget.dart
    ├── carrito_list_item.dart
    └── carrito_detail_dialog.dart
```

## 🌐 Configuración de API

La aplicación está configurada para consumir la API backend en:
- **URL Base**: `http://localhost:8000`

Para cambiar la URL de la API, modificar en `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://tu-servidor:puerto';
```

## 🔧 Funcionalidades Implementadas

### ✅ Productos
- [x] Visualizar lista de productos
- [x] Mostrar información detallada (nombre, precio, stock, categoría)
- [x] Agregar productos al carrito
- [x] Validación de stock disponible

### ✅ Carrito de Compras
- [x] Agregar productos al carrito local
- [x] Modificar cantidades
- [x] Eliminar productos del carrito
- [x] Calcular total automáticamente
- [x] Registrar carrito en el servidor
- [x] Limpiar carrito

### ✅ Historial de Carritos
- [x] Listar carritos registrados
- [x] Ver detalles de cada carrito
- [x] Eliminar carritos del servidor

## 🎨 Características de UI/UX

- **Diseño responsive**: Adaptable a diferentes tamaños de pantalla
- **Tema personalizado**: Colores y estilos consistentes
- **Indicadores visuales**: Loading, errores, estados vacíos
- **Navegación intuitiva**: Flow natural entre pantallas
- **Feedback visual**: SnackBars para confirmar acciones

## 🚦 Estados de la Aplicación

### Manejo de Errores
- Conexión fallida con la API
- Productos sin stock
- Errores al registrar carrito
- Mensajes informativos al usuario

### Estados de Carga
- Indicadores mientras se cargan datos
- Botones deshabilitados durante operaciones
- Pull-to-refresh en listas

## 📱 Comandos Útiles

```bash
# Ejecutar en modo debug
flutter run

# Ejecutar en modo release
flutter run --release

# Generar APK
flutter build apk

# Limpiar proyecto
flutter clean

# Actualizar dependencias
flutter pub upgrade

# Analizar código
flutter analyze
```

## 🔗 Integración con Backend

La app se conecta con la API REST de FastAPI:

### Endpoints Consumidos:
- `GET /productos` - Obtener lista de productos
- `GET /carrito` - Obtener lista de carritos
- `POST /carrito` - Crear nuevo carrito
- `PUT /carrito/{id}` - Actualizar carrito
- `DELETE /carrito/{id}` - Eliminar carrito

## 🐛 Solución de Problemas

### Error de conexión:
- Verificar que el backend esté ejecutándose
- Confirmar la URL de la API en `api_service.dart`
- Verificar conectividad de red

### Problemas de dependencias:
```bash
flutter clean
flutter pub get
```

### Problemas de compilación:
```bash
flutter doctor
flutter pub deps
```

## 🔄 Próximas Mejoras

- [ ] Autenticación de usuarios
- [ ] Búsqueda y filtrado de productos
- [ ] Categorías de productos
- [ ] Favoritos
- [ ] Notificaciones push
- [ ] Modo offline
- [ ] Animaciones mejoradas
