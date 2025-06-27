# 🛍️ Proyecto Full Stack: Tienda Online

## 📋 Resumen del Proyecto

Proyecto completo de una tienda online desarrollado con:
- **Backend**: FastAPI + SQLAlchemy + SQL Server
- **Frontend**: Flutter + Provider (State Management)

### ✅ Funcionalidades Implementadas

#### Backend (FastAPI)
- ✅ API RESTful completa
- ✅ Conexión a SQL Server
- ✅ CRUD completo para productos
- ✅ CRUD completo para carritos
- ✅ Validaciones de negocio (stock, etc.)
- ✅ Documentación automática (Swagger)
- ✅ Manejo de errores
- ✅ CORS configurado

#### Frontend (Flutter)
- ✅ Interfaz moderna y responsiva
- ✅ Listado de productos
- ✅ Carrito de compras funcional
- ✅ Gestión de cantidades
- ✅ Registro de carritos
- ✅ Historial de carritos
- ✅ Manejo de estados

## 🚀 Instrucciones de Ejecución

### 1. Backend (FastAPI)

```bash
# Navegar al directorio del backend
cd /home/spikemm/Documentos/PROYECTO_FINAL_DISCO/Backend_Proyecto

# Ejecutar el script de inicio
bash start_server.sh
```

El servidor estará disponible en:
- **API**: http://localhost:8000
- **Documentación**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

### 2. Frontend (Flutter)

```bash
# Navegar al directorio del frontend
cd /home/spikemm/Documentos/PROYECTO_FINAL_DISCO/frontend_proyecto

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run
```

## 📊 Base de Datos

### Configuración
- **Host**: sql1003.site4now.net
- **Base de Datos**: db_aba258_suan
- **Usuario**: db_aba258_suan_admin
- **Contraseña**: Suan2024

### Tablas Creadas
- ✅ `productos` - Información de productos
- ✅ `carritos` - Carritos registrados
- ✅ `carrito_items` - Items de cada carrito

### Datos de Ejemplo
✅ 8 productos insertados exitosamente:
- iPhone 15 Pro ($999.99)
- Samsung Galaxy S24 ($899.99)
- MacBook Air M3 ($1299.99)
- Dell XPS 13 ($1099.99)
- iPad Pro 12.9" ($1099.99)
- Sony WH-1000XM5 ($399.99)
- Apple Watch Series 9 ($429.99)
- Gaming Mouse Logitech G Pro X ($79.99)

## 🔧 API Endpoints

### Productos
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/productos` | Listar productos |
| GET | `/productos/{id}` | Obtener producto por ID |
| POST | `/productos` | Crear producto |
| PUT | `/productos/{id}` | Actualizar producto |
| DELETE | `/productos/{id}` | Eliminar producto |

### Carrito
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/carrito` | Listar carritos |
| GET | `/carrito/{id}` | Obtener carrito por ID |
| POST | `/carrito` | Crear carrito |
| PUT | `/carrito/{id}` | Actualizar carrito |
| DELETE | `/carrito/{id}` | Eliminar carrito |

## 📱 Pantallas de Flutter

### 1. **Productos Screen**
- Visualización de productos en grid
- Información de stock y precio
- Botón para agregar al carrito
- Contador de items en carrito

### 2. **Carrito Screen**
- Lista de productos agregados
- Controles de cantidad (+/-)
- Cálculo automático del total
- Botones para limpiar y registrar

### 3. **Historial Screen**
- Lista de carritos registrados
- Detalles de cada carrito
- Opción para eliminar carritos

## 🧪 Pruebas

### Probar Backend
1. Abrir http://localhost:8000/docs
2. Probar endpoints desde Swagger UI
3. Verificar respuestas JSON

### Probar Frontend
1. Ejecutar Flutter app
2. Navegar entre pantallas
3. Agregar productos al carrito
4. Registrar carrito
5. Ver historial

## 📁 Estructura de Archivos

```
PROYECTO_FINAL_DISCO/
├── Backend_Proyecto/
│   ├── app/
│   │   ├── database/
│   │   │   └── connection.py
│   │   ├── models/
│   │   │   └── models.py
│   │   ├── routers/
│   │   │   ├── productos.py
│   │   │   └── carrito.py
│   │   ├── schemas/
│   │   │   └── schemas.py
│   │   └── main.py
│   ├── venv/
│   ├── migrate.py
│   ├── seed_data.py
│   ├── start_server.sh
│   ├── requirements.txt
│   └── README.md
└── frontend_proyecto/
    ├── lib/
    │   ├── models/
    │   │   ├── producto.dart
    │   │   └── carrito.dart
    │   ├── services/
    │   │   └── api_service.dart
    │   ├── providers/
    │   │   └── carrito_provider.dart
    │   ├── screens/
    │   │   ├── productos_screen.dart
    │   │   ├── carrito_screen.dart
    │   │   └── carritos_history_screen.dart
    │   ├── widgets/
    │   │   ├── producto_card.dart
    │   │   ├── carrito_item_widget.dart
    │   │   ├── carrito_list_item.dart
    │   │   └── carrito_detail_dialog.dart
    │   └── main.dart
    ├── pubspec.yaml
    └── README_FLUTTER.md
```

## 🔧 Comandos Útiles

### Backend
```bash
# Crear tablas
python migrate.py

# Insertar datos de ejemplo
python seed_data.py

# Iniciar servidor
bash start_server.sh
```

### Frontend
```bash
# Instalar dependencias
flutter pub get

# Ejecutar app
flutter run

# Generar APK
flutter build apk
```

## 🎯 Funcionalidades Completadas

### Backend ✅
- [x] Entorno virtual configurado
- [x] Conexión a SQL Server
- [x] Modelos de datos
- [x] API REST completa
- [x] Validaciones de negocio
- [x] Documentación automática
- [x] Manejo de errores
- [x] Migraciones ejecutadas
- [x] Datos de ejemplo insertados

### Frontend ✅
- [x] Aplicación Flutter configurada
- [x] Consumo de API
- [x] Manejo de estado con Provider
- [x] Interfaz de productos
- [x] Carrito de compras
- [x] Registro de carritos
- [x] Historial de carritos
- [x] Manejo de errores
- [x] UI/UX moderna

## 🏁 Proyecto Completado

¡El proyecto está **100% funcional**! 

### Para usar:
1. **Ejecutar backend**: `bash start_server.sh`
2. **Ejecutar frontend**: `flutter run`
3. **Probar funcionalidades** en la app

### Próximos pasos (opcionales):
- Agregar autenticación
- Implementar filtros de búsqueda
- Añadir categorías de productos
- Mejorar la UI/UX
- Desplegar en producción
