from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database.connection import Base

class Producto(Base):
    __tablename__ = "productos"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(255), nullable=False)
    descripcion = Column(Text)
    precio = Column(Float, nullable=False)
    stock = Column(Integer, nullable=False, default=0)
    imagen_url = Column(String(500))
    categoria = Column(String(100))
    fecha_creacion = Column(DateTime(timezone=True), server_default=func.now())
    fecha_actualizacion = Column(DateTime(timezone=True), onupdate=func.now())

    # Relación con items del carrito
    carrito_items = relationship("CarritoItem", back_populates="producto")

class Carrito(Base):
    __tablename__ = "carritos"

    id = Column(Integer, primary_key=True, index=True)
    fecha_creacion = Column(DateTime(timezone=True), server_default=func.now())
    fecha_actualizacion = Column(DateTime(timezone=True), onupdate=func.now())
    total = Column(Float, default=0.0)
    estado = Column(String(50), default="activo")  # activo, completado, cancelado

    # Relación con items del carrito
    items = relationship("CarritoItem", back_populates="carrito", cascade="all, delete-orphan")

class CarritoItem(Base):
    __tablename__ = "carrito_items"

    id = Column(Integer, primary_key=True, index=True)
    carrito_id = Column(Integer, ForeignKey("carritos.id"), nullable=False)
    producto_id = Column(Integer, ForeignKey("productos.id"), nullable=False)
    cantidad = Column(Integer, nullable=False, default=1)
    precio_unitario = Column(Float, nullable=False)
    subtotal = Column(Float, nullable=False)

    # Relaciones
    carrito = relationship("Carrito", back_populates="items")
    producto = relationship("Producto", back_populates="carrito_items")
