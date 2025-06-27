from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.database.connection import get_db
from app.models.models import Producto as ProductoModel
from app.schemas.schemas import (
    Producto, 
    ProductoCreate, 
    ProductoUpdate, 
    ProductoResponse,
    ProductosListResponse
)

router = APIRouter(
    prefix="/productos",
    tags=["productos"]
)

@router.get("/", response_model=ProductosListResponse)
async def get_productos(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """Obtener lista de productos"""
    productos = db.query(ProductoModel).offset(skip).limit(limit).all()
    total = db.query(ProductoModel).count()
    
    return ProductosListResponse(
        productos=productos,
        total=total
    )

@router.get("/{producto_id}", response_model=Producto)
async def get_producto(
    producto_id: int,
    db: Session = Depends(get_db)
):
    """Obtener un producto por ID"""
    producto = db.query(ProductoModel).filter(ProductoModel.id == producto_id).first()
    
    if not producto:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Producto no encontrado"
        )
    
    return producto

@router.post("/", response_model=ProductoResponse, status_code=status.HTTP_201_CREATED)
async def create_producto(
    producto: ProductoCreate,
    db: Session = Depends(get_db)
):
    """Crear un nuevo producto"""
    db_producto = ProductoModel(**producto.dict())
    
    try:
        db.add(db_producto)
        db.commit()
        db.refresh(db_producto)
        
        return ProductoResponse(
            message="Producto creado exitosamente",
            producto=db_producto
        )
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Error al crear el producto: {str(e)}"
        )

@router.put("/{producto_id}", response_model=ProductoResponse)
async def update_producto(
    producto_id: int,
    producto_update: ProductoUpdate,
    db: Session = Depends(get_db)
):
    """Actualizar un producto"""
    db_producto = db.query(ProductoModel).filter(ProductoModel.id == producto_id).first()
    
    if not db_producto:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Producto no encontrado"
        )
    
    # Actualizar solo los campos que fueron proporcionados
    update_data = producto_update.dict(exclude_unset=True)
    
    try:
        for field, value in update_data.items():
            setattr(db_producto, field, value)
        
        db.commit()
        db.refresh(db_producto)
        
        return ProductoResponse(
            message="Producto actualizado exitosamente",
            producto=db_producto
        )
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Error al actualizar el producto: {str(e)}"
        )

@router.delete("/{producto_id}", response_model=ProductoResponse)
async def delete_producto(
    producto_id: int,
    db: Session = Depends(get_db)
):
    """Eliminar un producto"""
    db_producto = db.query(ProductoModel).filter(ProductoModel.id == producto_id).first()
    
    if not db_producto:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Producto no encontrado"
        )
    
    try:
        db.delete(db_producto)
        db.commit()
        
        return ProductoResponse(
            message="Producto eliminado exitosamente"
        )
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Error al eliminar el producto: {str(e)}"
        )
