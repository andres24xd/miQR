# miQR - Herramienta CLI para Generar Códigos QR 🔳

`miqr` es una herramienta ligera y modular diseñada para generar códigos QR de forma rápida y eficiente directamente desde la terminal de Linux. Es ideal para desarrolladores y usuarios avanzados que prefieren la potencia de la línea de comandos.

## ✨ Características

* **Visualización en terminal:** Muestra el código QR directamente en la consola usando caracteres ASCII.
* **Exportación a imagen:** Guarda el código en formato PNG de alta calidad.
* **Personalización de colores:** Soporte para cambiar el color de frente (`-f`) y de fondo (`-b`).
* **Soporte para Tuberías (Pipes):** Integra la generación de QRs en scripts complejos mediante el uso de pipes de Linux.
* **Modularidad:** Construido en Python bajo una arquitectura de clases.

## 🚀 Instalación

Para instalar la herramienta y todas sus dependencias en cualquier distribución de Linux, utiliza el script de instalación incluido:

\`\`\`bash
chmod +x miQR.sh
sudo ./miQR.sh
\`\`\`

## 💡 Ejemplos de Uso

**1. Ver el QR en la terminal:**
\`\`\`bash
miqr -d "Hola Mundo"
\`\`\`

**2. Guardar como imagen PNG:**
\`\`\`bash
miqr -d "https://google.com" -o buscador.png
\`\`\`

**3. Colores personalizados (Azul sobre Gris claro):**
\`\`\`bash
miqr -d "Datos" -o color.png -f blue -b lightgray
\`\`\`

**4. Usar con tuberías:**
\`\`\`bash
echo "Texto desde un pipe" | miqr -o pipe.png
\`\`\`

## 👨‍💻 Autor

Desarrollado por **Andrés Sánchez**.
