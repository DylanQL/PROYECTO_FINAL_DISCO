#!/bin/bash

# Script para ejecutar el servidor FastAPI
# Ejecutar con: bash start_server.sh

echo "🚀 Iniciando servidor de la Tienda Online API..."
echo "📂 Directorio actual: $(pwd)"

# Verificar que estamos en el directorio correcto
if [ ! -f "app/main.py" ]; then
    echo "❌ Error: No se encuentra app/main.py"
    echo "📍 Asegúrate de ejecutar este script desde el directorio Backend_Proyecto"
    exit 1
fi

# Activar entorno virtual si existe
if [ -f "venv/bin/activate" ]; then
    echo "🔧 Activando entorno virtual..."
    source venv/bin/activate
    PYTHON_CMD="python"
else
    echo "⚠️  Usando Python del sistema..."
    PYTHON_CMD="python3"
fi

# Verificar que las dependencias están instaladas
echo "🔍 Verificando dependencias..."
$PYTHON_CMD -c "import fastapi, uvicorn, sqlalchemy" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Error: Faltan dependencias. Instalando..."
    $PYTHON_CMD -m pip install -r requirements.txt
fi

# Ejecutar migraciones si es necesario
echo "🗄️  Ejecutando migraciones..."
$PYTHON_CMD migrate.py

# Iniciar servidor
echo "🌐 Iniciando servidor en http://localhost:8000"
echo "📚 Documentación disponible en http://localhost:8000/docs"
echo "🛑 Para detener el servidor, presiona Ctrl+C"
echo ""

$PYTHON_CMD -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
