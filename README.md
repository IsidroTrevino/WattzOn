
# ⚡️ Wattzon

**Aplicación Móvil en iOS para el monitoreo del consumo energético en el hogar**  

---

## 📚 Tabla de Contenido

1. [🛠️ Requisitos del Sistema](#-requisitos-del-sistema)
2. [🚀 Instalación](#-instalación)
   - [Clonar Repositorios](#clonar-repositorios)
   - [Configurar Simulador](#configurar-simulador)
   - [Ejecutar el Proyecto](#ejecutar-el-proyecto)
3. [💡 Gracias por Usar Wattzon](#-gracias-por-usar-wattzon)

---

## 🛠️ Requisitos del Sistema

- 📱 **iOS 17.0** o superior.  
- 💻 **Xcode 16** o superior.  
- 🌐 Conexión a internet (si es necesario).  

---

## 🚀 Instalación

### 1. Clonar Repositorios  

1. **Clona este repositorio para la aplicación móvil:**  
   ```bash
   git clone https://github.com/IsidroTrevino/WattzOn
   ```  

2. **Clona este repositorio para la API:**  
   ```bash
   git clone https://github.com/IsidroTrevino/WattzOnAPI
   ```  

---

### 2. Configurar Simulador  

Para probar la aplicación, es necesario configurar un simulador compatible con iOS 17:  

1. Abre **Xcode** y dirígete al menú `Xcode > Settings` o `Preferences`.  
2. Ve a la pestaña **Platforms** y descarga el simulador de iOS 17 si aún no lo tienes instalado.  
3. Selecciona el simulador en la barra de destino del proyecto en Xcode, como por ejemplo:  
   - iPhone 14 (iOS 17.0)  
   - iPhone SE (3ra generación, iOS 17.0)  

---

### 3. Ejecutar el Proyecto  

Si deseas ejecutar la aplicación en un dispositivo físico:  

1. Conecta tu dispositivo iOS al equipo mediante un cable USB.  
2. Asegúrate de que tu dispositivo tenga instalada la última versión de iOS compatible.  
3. En **Xcode**, selecciona tu dispositivo físico como destino de compilación.  
4. Presiona `Cmd + R` para compilar y ejecutar la aplicación.  

Para instalar y probar en un dispositivo externo:  

1. Firma tu aplicación usando un certificado de desarrollador válido en **Xcode > Signing & Capabilities**.  
2. Exporta el archivo `.ipa` y usa una herramienta como **Apple Configurator** o **TestFlight** para instalarlo en el dispositivo.  

---

## 💡 Gracias por Usar Wattzon

¡Esperamos que Wattzon sea útil para monitorear tu consumo energético! Si tienes dudas o sugerencias, no dudes en contribuir al proyecto o crear un issue en GitHub. ✨  
