"""
Script para insertar datos de ejemplo en la base de datos
"""
from app.database.connection import SessionLocal
from app.models.models import Producto

def create_sample_data():
    """Crear productos de ejemplo"""
    db = SessionLocal()
    
    try:
        # Verificar si ya hay productos
        if db.query(Producto).count() > 0:
            print("✅ Ya existen productos en la base de datos")
            return
        
        # Productos de ejemplo
        productos_ejemplo = [
            {
                "nombre": "iPhone 15 Pro",
                "descripcion": "El último modelo de iPhone con cámara pro y chip A17 Pro",
                "precio": 999.99,
                "stock": 25,
                "categoria": "Smartphones",
                "imagen_url": "https://example.com/iphone15pro.jpg"
            },
            {
                "nombre": "Samsung Galaxy S24",
                "descripcion": "Smartphone Android de alta gama con pantalla OLED",
                "precio": 899.99,
                "stock": 30,
                "categoria": "Smartphones",
                "imagen_url": "https://example.com/galaxys24.jpg"
            },
            {
                "nombre": "MacBook Air M3",
                "descripcion": "Laptop ultradelgada con chip M3 de Apple",
                "precio": 1299.99,
                "stock": 15,
                "categoria": "Laptops",
                "imagen_url": "https://example.com/macbookair.jpg"
            },
            {
                "nombre": "Dell XPS 13",
                "descripcion": "Laptop compacta con procesador Intel de 12va generación",
                "precio": 1099.99,
                "stock": 20,
                "categoria": "Laptops",
                "imagen_url": "https://example.com/dellxps13.jpg"
            },
            {
                "nombre": "iPad Pro 12.9\"",
                "descripcion": "Tablet profesional con pantalla Liquid Retina XDR",
                "precio": 1099.99,
                "stock": 18,
                "categoria": "Tablets",
                "imagen_url": "https://example.com/ipadpro.jpg"
            },
            {
                "nombre": "Sony WH-1000XM5",
                "descripcion": "Audífonos con cancelación de ruido premium",
                "precio": 399.99,
                "stock": 40,
                "categoria": "Audio",
                "imagen_url": "https://example.com/sonywh1000xm5.jpg"
            },
            {
                "nombre": "Apple Watch Series 9",
                "descripcion": "Smartwatch con GPS y medición de oxígeno en sangre",
                "precio": 429.99,
                "stock": 35,
                "categoria": "Wearables",
                "imagen_url": "https://example.com/applewatch9.jpg"
            },
            {
                "nombre": "Gaming Mouse Logitech G Pro X",
                "descripcion": "Mouse gaming profesional con sensor HERO 25K",
                "precio": 79.99,
                "stock": 50,
                "categoria": "Gaming",
                "imagen_url": "https://example.com/logitechgpro.jpg"
            }
        ]
        
        print("📝 Insertando productos de ejemplo...")
        
        for producto_data in productos_ejemplo:
            producto = Producto(**producto_data)
            db.add(producto)
        
        db.commit()
        print(f"✅ Se insertaron {len(productos_ejemplo)} productos exitosamente!")
        
        # Mostrar productos creados
        productos = db.query(Producto).all()
        print(f"\n📦 Productos en la base de datos:")
        for producto in productos:
            print(f"  - {producto.id}: {producto.nombre} - ${producto.precio} (Stock: {producto.stock})")
            
    except Exception as e:
        db.rollback()
        print(f"❌ Error al insertar datos: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    create_sample_data()
