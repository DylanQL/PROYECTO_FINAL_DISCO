from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import urllib.parse

# Configuración de conexión a SQL Server
SERVER = 'localhost\\SQLEXPRESS'  # Usando la instancia local SQLEXPRESS común
DATABASE = 'db_disco'
USERNAME = 'user_disco'
PASSWORD = '123456'

# URL de conexión para SQL Server
password_encoded = urllib.parse.quote_plus(PASSWORD)
SQLALCHEMY_DATABASE_URL = f"mssql+pyodbc://{USERNAME}:{password_encoded}@{SERVER}/{DATABASE}?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes"

# Crear engine
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# Crear SessionLocal class
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Crear Base class
Base = declarative_base()

# Dependency para obtener DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
