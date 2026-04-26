#!/bin/bash

# 1. Verificar si el script se está ejecutando con permisos de administrador (root)
if [ "$EUID" -ne 0 ]; then
  echo "⚠️  Por favor ejecuta este script como administrador:"
  echo "   sudo ./install.sh"
  exit 1
fi

echo "⚙️  Detectando sistema e instalando dependencias..."

# 2. Detectar el gestor de paquetes del sistema para instalar las librerías nativas
if command -v dnf &> /dev/null; then
    # Fedora / RHEL
    dnf install -y python3 python3-pip python3-qrcode python3-pillow python3-argcomplete
elif command -v apt-get &> /dev/null; then
    # Ubuntu / Debian
    apt-get update
    apt-get install -y python3 python3-pip python3-qrcode python3-pil python3-argcomplete
elif command -v pacman &> /dev/null; then
    # Arch Linux / Manjaro
    pacman -Sy --noconfirm python python-pip python-qrcode python-pillow python-argcomplete
elif command -v zypper &> /dev/null; then
    # openSUSE
    zypper install -y python3 python3-pip python3-qrcode python3-Pillow python3-argcomplete
else
    echo "⚠️  Gestor de paquetes no reconocido. Intentando instalar vía pip..."
    pip3 install qrcode[pil] argcomplete --break-system-packages
fi

echo "🚀 Instalando miqr en el sistema..."

# 3. Crear el archivo Python directamente en la ruta de binarios del sistema (/usr/local/bin)
cat << 'EOF' > /usr/local/bin/miqr
#!/usr/bin/env python3
# PYTHON_ARGCOMPLETE_OK
# ==========================================
# Herramienta CLI: miqr
# Desarrollador: Andres Sanchez
# ==========================================

import qrcode
import argparse
import sys
import os
import argcomplete

class GeneradorQR:
    """Clase para manejar la generación de códigos QR de forma modular."""
    
    def __init__(self, version=1, box_size=10, border=4):
        self.qr = qrcode.QRCode(
            version=version,
            error_correction=qrcode.constants.ERROR_CORRECT_H,
            box_size=box_size,
            border=border,
        )

    def crear_imagen(self, datos, salida, color_frente="black", color_fondo="white"):
        self.qr.add_data(datos)
        self.qr.make(fit=True)
        try:
            img = self.qr.make_image(fill_color=color_frente, back_color=color_fondo)
            img.save(salida)
            print(f"✅ Código QR guardado en: {os.path.abspath(salida)}")
        except Exception as e:
            print(f"❌ Error al guardar la imagen: {e}")
            sys.exit(1)

    def imprimir_terminal(self, datos):
        self.qr.add_data(datos)
        self.qr.make(fit=True)
        print("\n")
        self.qr.print_ascii(invert=True) 
        print("\n")

def main():
    # Texto de ayuda personalizado con ejemplos
    ejemplos = """
Ejemplos de uso:
  1. Imprimir QR en la terminal:
     miqr -d "Hola Mundo"
  
  2. Guardar QR en un archivo PNG:
     miqr -d "https://tu-sitio.com" -o web.png
  
  3. Usar colores personalizados:
     miqr -d "Datos" -o color.png -f blue -b lightgray
  
  4. Usar tuberías (pipes) de Linux:
     echo "Texto secreto" | miqr -o secreto.png
"""
    parser = argparse.ArgumentParser(
        description="Herramienta CLI para generar códigos QR.\nDesarrollado por: Andres Sanchez",
        epilog=ejemplos,
        formatter_class=argparse.RawDescriptionHelpFormatter 
    )
    
    parser.add_argument("-d", "--datos", help="Datos del QR. Lee de pipe (|) si se omite.")
    parser.add_argument("-o", "--output", help="Archivo de salida (ej. qr.png). Si no se indica, se imprime en terminal.")
    parser.add_argument("-f", "--frente", default="black", help="Color principal (defecto: black).")
    parser.add_argument("-b", "--fondo", default="white", help="Color de fondo (defecto: white).")
    
    # ¡Magia del autocompletado!
    argcomplete.autocomplete(parser)
    
    args = parser.parse_args()

    # Lógica de datos
    datos = args.datos
    if not sys.stdin.isatty():
        datos_pipe = sys.stdin.read().strip()
        if datos_pipe:
            datos = datos_pipe
            
    if not datos:
        parser.error("Debes proporcionar datos usando -d o a través de un pipe (|).\nEscribe 'miqr -h' para ver la ayuda.")

    generador = GeneradorQR()

    if args.output:
        generador.crear_imagen(datos, args.output, args.frente, args.fondo)
    else:
        generador.imprimir_terminal(datos)

if __name__ == "__main__":
    main()
EOF

# 4. Dar permisos de ejecución al comando
chmod +x /usr/local/bin/miqr

# 5. Intentar activar el autocompletado global si la herramienta está disponible
if command -v activate-global-python-argcomplete &> /dev/null; then
    activate-global-python-argcomplete &> /dev/null
fi

# 6. Pantalla final de éxito y modo de uso
echo ""
echo "=========================================================="
echo " 🎉 ¡INSTALACIÓN COMPLETADA CON ÉXITO! 🎉"
echo "=========================================================="
echo " La herramienta 'miqr' (creada por Andres Sanchez) "
echo " ya está instalada y lista para usarse desde cualquier ruta."
echo ""
echo " 📌 CÓMO USARLA:"
echo " --------------------------------------------------------"
echo " 🔹 Ver la ayuda y documentación:"
echo "    miqr -h"
echo ""
echo " 🔹 Crear un QR rápido en la terminal:"
echo "    miqr -d 'Hola Andres'"
echo ""
echo " 🔹 Exportar un QR con colores personalizados:"
echo "    miqr -d 'Mi portafolio' -o firma.png -f blue"
echo ""
echo " 🔹 Usar pipes (tuberías de Linux):"
echo "    echo 'Texto oculto' | miqr -o secreto.png"
echo "=========================================================="
echo " ¡A disfrutar automatizando! 💻"
echo ""
