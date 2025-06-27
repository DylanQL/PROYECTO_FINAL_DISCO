from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.database.connection import get_db
from app.models.models import Carrito as CarritoModel, CarritoItem as CarritoItemModel, Producto as ProductoModel
from app.schemas.schemas import (
    Carrito,
    CarritoCreate,
    CarritoUpdate,
    CarritoResponse,
    CarritosListResponse,
    CarritoItemCreate
)

router = APIRouter(
    prefix="/carrito",
    tags=["carrito"]
)

def calcular_total_carrito(carrito_items):
    """Calcular el total del carrito basado en los items"""
    total = 0.0
    for item in carrito_items:
        total += item.subtotal
    return total

@router.get("/", response_model=CarritosListResponse)
async def get_carritos(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """Obtener lista de todos los carritos"""
    carritos = db.query(CarritoModel).order_by(CarritoModel.id).offset(skip).limit(limit).all()
    total = db.query(CarritoModel).count()
    
    return CarritosListResponse(
        carritos=carritos,
        total=total
    )

@router.get("/{carrito_id}", response_model=Carrito)
async def get_carrito(
    carrito_id: int,
    db: Session = Depends(get_db)
):
    """Obtener detalle de un carrito específico"""
    carrito = db.query(CarritoModel).filter(CarritoModel.id == carrito_id).first()
    
    if not carrito:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Carrito no encontrado"
        )
    
    return carrito

@router.post("/", response_model=CarritoResponse, status_code=status.HTTP_201_CREATED)
async def create_carrito(
    carrito_data: CarritoCreate,
    db: Session = Depends(get_db)
):
    """Crear un nuevo carrito con productos"""
    try:
        # Crear el carrito
        db_carrito = CarritoModel()
        db.add(db_carrito)
        db.flush()  # Para obtener el ID
        
        total_carrito = 0.0
        
        # Agregar items al carrito
        for item_data in carrito_data.items:
            # Verificar que el producto existe
            producto = db.query(ProductoModel).filter(ProductoModel.id == item_data.producto_id).first()
            if not producto:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail=f"Producto con ID {item_data.producto_id} no encontrado"
                )
            
            # Verificar stock suficiente
            if producto.stock < item_data.cantidad:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Stock insuficiente para el producto {producto.nombre}. Stock disponible: {producto.stock}"
                )
            
            # Crear item del carrito
            subtotal = producto.precio * item_data.cantidad
            db_item = CarritoItemModel(
                carrito_id=db_carrito.id,
                producto_id=item_data.producto_id,
                cantidad=item_data.cantidad,
                precio_unitario=producto.precio,
                subtotal=subtotal
            )
            
            db.add(db_item)
            total_carrito += subtotal
        
        # Actualizar total del carrito
        db_carrito.total = total_carrito
        
        db.commit()
        db.refresh(db_carrito)
        
        return CarritoResponse(
            message="Carrito creado exitosamente",
            carrito=db_carrito
        )
        
    except HTTPException:
        db.rollback()
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Error al crear el carrito: {str(e)}"
        )

@router.put("/{carrito_id}", response_model=CarritoResponse)
async def update_carrito(
    carrito_id: int,
    carrito_update: CarritoUpdate,
    db: Session = Depends(get_db)
):
    """Actualizar productos y cantidades en un carrito"""
    carrito = db.query(CarritoModel).filter(CarritoModel.id == carrito_id).first()
    
    if not carrito:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Carrito no encontrado"
        )
    
    try:
        # Eliminar todos los items existentes
        db.query(CarritoItemModel).filter(CarritoItemModel.carrito_id == carrito_id).delete()
        
        total_carrito = 0.0
        
        # Agregar los nuevos items
        for item_data in carrito_update.items:
            # Verificar que el producto existe
            producto = db.query(ProductoModel).filter(ProductoModel.id == item_data.producto_id).first()
            if not producto:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail=f"Producto con ID {item_data.producto_id} no encontrado"
                )
            
            # Verificar stock suficiente
            if producto.stock < item_data.cantidad:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Stock insuficiente para el producto {producto.nombre}. Stock disponible: {producto.stock}"
                )
            
            # Crear nuevo item
            subtotal = producto.precio * item_data.cantidad
            db_item = CarritoItemModel(
                carrito_id=carrito_id,
                producto_id=item_data.producto_id,
                cantidad=item_data.cantidad,
                precio_unitario=producto.precio,
                subtotal=subtotal
            )
            
            db.add(db_item)
            total_carrito += subtotal
        
        # Actualizar total del carrito
        carrito.total = total_carrito
        
        db.commit()
        db.refresh(carrito)
        
        return CarritoResponse(
            message="Carrito actualizado exitosamente",
            carrito=carrito
        )
        
    except HTTPException:
        db.rollback()
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Error al actualizar el carrito: {str(e)}"
        )

@router.delete("/{carrito_id}", response_model=CarritoResponse)
async def delete_carrito(
    carrito_id: int,
    db: Session = Depends(get_db)
):
    """Eliminar un carrito"""
    carrito = db.query(CarritoModel).filter(CarritoModel.id == carrito_id).first()
    
    if not carrito:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Carrito no encontrado"
        )
    
    try:
        db.delete(carrito)
        db.commit()
        
        return CarritoResponse(
            message="Carrito eliminado exitosamente"
        )
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Error al eliminar el carrito: {str(e)}"
        )
