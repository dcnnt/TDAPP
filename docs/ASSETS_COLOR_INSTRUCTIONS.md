# 📁 Instrucciones: Crear Color Sets en Xcode

## Paso 1: Crear carpeta Colors en Assets

1. En Xcode, abre **Assets.xcassets**
2. **Clic derecho** en el espacio vacío > **New Folder**
3. Nombra la carpeta: **`Colors`**

---

## Paso 2: Crear cada Color Set

Para cada color, repite estos pasos:

### 2.1 Crear Color Set
1. **Clic derecho** en la carpeta `Colors` > **New Color Set**
2. Renombra el color set (ver nombres abajo)

### 2.2 Configurar Light Mode
1. Selecciona el color set
2. En el **Inspector de Atributos** (panel derecho), bajo "Appearances":
   - Asegúrate de que "Any Appearance" esté visible
3. Haz **doble clic** en el cuadrado de color (Light)
4. En el **Color Picker**, cambia a **RGB Sliders**
5. Ingresa los valores **Light** (ver abajo)

### 2.3 Añadir Dark Mode
1. Con el color set seleccionado
2. Inspector de Atributos > **Appearances** > clic en **"+"**
3. Elige **"Dark"**
4. Ahora verás 2 cuadrados: Light y Dark
5. Doble clic en el cuadrado **Dark**
6. Ingresa los valores **Dark** (ver abajo)

---

## 🎨 COLORES A CREAR (6 Color Sets)

### 1. PaperBackground
**Light Mode:**
- Hex: `#F5F1E8`
- RGB: 245, 241, 232
- HSB: 39°, 5%, 96%

**Dark Mode:**
- Hex: `#3A3530`
- RGB: 58, 53, 48
- HSB: 30°, 17%, 23%

---

### 2. Accent
**Light Mode:**
- Hex: `#7A8B6F`
- RGB: 122, 139, 111
- HSB: 96°, 20%, 55%

**Dark Mode:**
- Hex: `#8A9B7F`
- RGB: 138, 155, 127
- HSB: 96°, 18%, 61%

---

### 3. Ink
**Light Mode:**
- Hex: `#2C2A26`
- RGB: 44, 42, 38
- HSB: 40°, 14%, 17%

**Dark Mode:**
- Hex: `#E8E4DC`
- RGB: 232, 228, 220
- HSB: 40°, 5%, 91%

---

### 4. InkMuted
**Light Mode:**
- Hex: `#6B6762`
- RGB: 107, 103, 98
- HSB: 33°, 8%, 42%

**Dark Mode:**
- Hex: `#A8A39E`
- RGB: 168, 163, 158
- HSB: 30°, 6%, 66%

---

### 5. Hairline
**Light Mode:**
- Hex: `#D9D5CD`
- RGB: 217, 213, 205
- HSB: 40°, 6%, 85%

**Dark Mode:**
- Hex: `#4A4540`
- RGB: 74, 69, 64
- HSB: 30°, 14%, 29%

---

### 6. Card (opcional, puede ser igual a PaperBackground)
**Light Mode:**
- Hex: `#FAF8F3`
- RGB: 250, 248, 243
- HSB: 43°, 3%, 98%

**Dark Mode:**
- Hex: `#3F3A35`
- RGB: 63, 58, 53
- HSB: 30°, 16%, 25%

---

## 📷 Paso 3: Verificar

Una vez creados todos, en la carpeta `Colors` debes ver:

```
Colors/
├── PaperBackground.colorset
├── Accent.colorset
├── Ink.colorset
├── InkMuted.colorset
├── Hairline.colorset
└── Card.colorset
```

Cada uno con 2 variantes (Light/Dark) en el Inspector.

---

## 🖼️ Paso 4: Crear carpeta Textures (para después)

1. **Clic derecho** en Assets.xcassets > **New Folder**
2. Nombra: **`Textures`**
3. Dentro, crearé un placeholder para **PaperGrain** después

---

## ✅ Verificación rápida

Para verificar que funcionan:

1. Abre cualquier archivo Swift
2. Escribe: `Color("PaperBackground")`
3. Debería autocompletar y **no dar error**
4. Repite con los otros 5 colores

---

## 🎯 Siguiente paso

Cuando hayas creado estos 6 Color Sets, dime "listo" y continuaré con:
- Actualizar Theme.swift
- Modificar Components.swift
- Rediseñar gráficos
- Aplicar tipografía
- Añadir placeholder de textura

**¿Alguna duda sobre cómo crear los Color Sets?**
