from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database.connection import engine, Base
from app.routers import productos, carrito

# Crear las tablas en la base de datos
Base.metadata.create_all(bind=engine)

# Crear la aplicación FastAPI
app = FastAPI(
    title="Tienda Online API",
    description="API RESTful para gestión de productos y carrito de compras",
    version="1.0.0"
)

# Configurar CORS para permitir conexiones desde Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, especificar los dominios permitidos
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Incluir los routers
app.include_router(productos.router)
app.include_router(carrito.router)

@app.get("/")
async def root():
    return {
        "message": "¡Bienvenido a la Tienda Online API!",
        "version": "1.0.0",
        "endpoints": {
            "productos": "/productos",
            "carrito": "/carrito",
            "docs": "/docs",
            "redoc": "/redoc"
        }
    }

@app.get("/health")
async def health_check():
    return {"status": "healthy", "message": "API funcionando correctamente"}
