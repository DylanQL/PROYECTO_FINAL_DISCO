from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

# Esquemas para Producto
class ProductoBase(BaseModel):
    nombre: str = Field(..., min_length=1, max_length=255)
    descripcion: Optional[str] = None
    precio: float = Field(..., gt=0)
    stock: int = Field(..., ge=0)
    imagen_url: Optional[str] = None
    categoria: Optional[str] = None

class ProductoCreate(ProductoBase):
    pass

class ProductoUpdate(BaseModel):
    nombre: Optional[str] = Field(None, min_length=1, max_length=255)
    descripcion: Optional[str] = None
    precio: Optional[float] = Field(None, gt=0)
    stock: Optional[int] = Field(None, ge=0)
    imagen_url: Optional[str] = None
    categoria: Optional[str] = None

class Producto(ProductoBase):
    id: int
    fecha_creacion: datetime
    fecha_actualizacion: Optional[datetime] = None

    class Config:
        from_attributes = True

# Esquemas para CarritoItem
class CarritoItemBase(BaseModel):
    producto_id: int
    cantidad: int = Field(..., gt=0)

class CarritoItemCreate(CarritoItemBase):
    pass

class CarritoItemUpdate(BaseModel):
    cantidad: int = Field(..., gt=0)

class CarritoItem(CarritoItemBase):
    id: int
    precio_unitario: float
    subtotal: float
    producto: Producto

    class Config:
        from_attributes = True

# Esquemas para Carrito
class CarritoBase(BaseModel):
    pass

class CarritoCreate(BaseModel):
    items: List[CarritoItemCreate] = []

class CarritoUpdate(BaseModel):
    items: List[CarritoItemCreate] = []

class Carrito(CarritoBase):
    id: int
    fecha_creacion: datetime
    fecha_actualizacion: Optional[datetime] = None
    total: float
    estado: str
    items: List[CarritoItem] = []

    class Config:
        from_attributes = True

# Esquemas de respuesta
class ProductoResponse(BaseModel):
    message: str
    producto: Optional[Producto] = None

class CarritoResponse(BaseModel):
    message: str
    carrito: Optional[Carrito] = None

class ProductosListResponse(BaseModel):
    productos: List[Producto]
    total: int

class CarritosListResponse(BaseModel):
    carritos: List[Carrito]
    total: int
