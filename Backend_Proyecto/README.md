# Backend API - Tienda Online

API RESTful desarrollada con FastAPI para la gestión de productos y carrito de compras.

## 🚀 Configuración del Entorno

### Prerrequisitos
- Python 3.8+
- SQL Server
- Driver ODBC para SQL Server

### Instalación

1. **Crear y activar entorno virtual:**
```bash
cd Backend_Proyecto
python3 -m venv venv
source venv/bin/activate  # En Linux/Mac
# venv\Scripts\activate    # En Windows
```

2. **Instalar dependencias:**
```bash
pip install -r requirements.txt
```

3. **Ejecutar migraciones:**
```bash
python migrate.py
```

4. **Iniciar el servidor:**
```bash
python run_server.py
```

La API estará disponible en: `http://localhost:8000`

## 📚 Documentación de la API

- **Swagger UI:** `http://localhost:8000/docs`
- **ReDoc:** `http://localhost:8000/redoc`

## 🗄️ Base de Datos

La aplicación se conecta a SQL Server con las siguientes credenciales:
- **Host:** sql1003.site4now.net
- **Base de Datos:** db_aba258_suan
- **Usuario:** db_aba258_suan_admin
- **Contraseña:** Suan2024

## 📦 Endpoints Disponibles

### Productos
- `GET /productos` - Listar productos
- `POST /productos` - Crear producto
- `PUT /productos/{id}` - Actualizar producto
- `DELETE /productos/{id}` - Eliminar producto
- `GET /productos/{id}` - Obtener producto por ID

### Carrito
- `GET /carrito` - Listar todos los carritos
- `POST /carrito` - Crear nuevo carrito con productos
- `GET /carrito/{id}` - Ver detalle de un carrito
- `PUT /carrito/{id}` - Editar productos y cantidades en un carrito
- `DELETE /carrito/{id}` - Eliminar un carrito

## 🏗️ Estructura del Proyecto

```
Backend_Proyecto/
├── app/
│   ├── __init__.py
│   ├── main.py              # Aplicación principal
│   ├── database/
│   │   ├── __init__.py
│   │   └── connection.py    # Configuración de BD
│   ├── models/
│   │   ├── __init__.py
│   │   └── models.py        # Modelos de SQLAlchemy
│   ├── schemas/
│   │   ├── __init__.py
│   │   └── schemas.py       # Esquemas de Pydantic
│   └── routers/
│       ├── __init__.py
│       ├── productos.py     # Endpoints de productos
│       └── carrito.py       # Endpoints de carrito
├── venv/                    # Entorno virtual
├── migrate.py              # Script de migraciones
├── run_server.py          # Script para ejecutar servidor
├── requirements.txt       # Dependencias
└── README.md             # Este archivo
```

## 🧪 Comandos Útiles

### Gestión de Base de Datos
```bash
# Crear tablas
python migrate.py create

# Eliminar tablas
python migrate.py drop

# Resetear base de datos (eliminar y crear)
python migrate.py reset
```

### Ejecutar el Servidor
```bash
# Modo desarrollo (con recarga automática)
python run_server.py

# Modo producción
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

## 🔧 Desarrollo

### Agregar Nuevos Endpoints
1. Crear o modificar modelos en `app/models/models.py`
2. Crear esquemas en `app/schemas/schemas.py`
3. Crear endpoints en `app/routers/`
4. Incluir router en `app/main.py`

### Testing
Para probar los endpoints, puedes usar:
- Swagger UI en `http://localhost:8000/docs`
- cURL o Postman
- Cliente HTTP de VS Code

## ⚠️ Notas Importantes

- Asegúrate de tener el driver ODBC para SQL Server instalado
- Las migraciones deben ejecutarse antes del primer uso
- El servidor por defecto corre en el puerto 8000
- CORS está configurado para permitir todas las conexiones (modificar en producción)
