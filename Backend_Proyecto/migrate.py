"""
Script para ejecutar las migraciones y crear las tablas en la base de datos
"""
from app.database.connection import engine, Base
from app.models.models import Producto, Carrito, CarritoItem

def create_tables():
    """Crear todas las tablas en la base de datos"""
    try:
        print("Creando tablas en la base de datos...")
        Base.metadata.create_all(bind=engine)
        print("✅ Tablas creadas exitosamente!")
        
        # Mostrar las tablas que se crearon
        print("\nTablas creadas:")
        for table in Base.metadata.tables.keys():
            print(f"  - {table}")
            
    except Exception as e:
        print(f"❌ Error al crear las tablas: {e}")
        return False
    
    return True

def drop_tables():
    """Eliminar todas las tablas de la base de datos"""
    try:
        print("Eliminando tablas de la base de datos...")
        Base.metadata.drop_all(bind=engine)
        print("✅ Tablas eliminadas exitosamente!")
    except Exception as e:
        print(f"❌ Error al eliminar las tablas: {e}")
        return False
    
    return True

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1:
        if sys.argv[1] == "drop":
            drop_tables()
        elif sys.argv[1] == "create":
            create_tables()
        elif sys.argv[1] == "reset":
            drop_tables()
            create_tables()
        else:
            print("Uso: python migrate.py [create|drop|reset]")
    else:
        create_tables()
