# 🖼️ Crear Textura de Papel - Placeholder

## Situación actual

El código ya está preparado para usar la textura de papel, pero necesitas crear la imagen.

En `BitacoraApp.swift` hay un `PaperTextureBackground` que busca:
- Nombre del asset: **`PaperGrain`**
- Ubicación: `Assets.xcassets/Textures/PaperGrain.imageset`
- Opacidad aplicada: 6% con blend mode multiply

---

## OPCIÓN 1: Crear placeholder simple (mientras generas la textura real)

### Paso 1: Crear carpeta Textures

1. En Xcode, abre **Assets.xcassets**
2. **Clic derecho** > **New Folder**
3. Nombra: **`Textures`**

### Paso 2: Crear Image Set placeholder

1. **Clic derecho** en la carpeta `Textures` > **New Image Set**
2. Renombra a: **`PaperGrain`**
3. Deja vacío por ahora (o arrastra una imagen blanca de 1x1px)

**Resultado:** La app no crasheará, simplemente no se verá la textura hasta que añadas la imagen real.

---

## OPCIÓN 2: Generar textura de papel realista

### Características de la textura ideal:

- **Tamaño:** 512x512px o 256x256px (tileable, se repite)
- **Formato:** PNG con transparencia (alpha channel)
- **Color:** Gris neutro (50% gris) para que blend mode multiply funcione
- **Patrón:** Grano de papel sutil, no muy visible
- **Seamless:** Los bordes deben conectar perfectamente (tileable)

### Cómo generarla:

**Método A: Con Photoshop/Affinity Photo**
1. Nuevo documento 512x512px
2. Capa con ruido: Filter > Noise > Add Noise (2-5%, Gaussian)
3. Blur muy sutil: Filter > Blur > Gaussian Blur (0.5-1px)
4. Ajustar niveles para reducir contraste
5. Guardar como PNG

**Método B: Con generador online**
1. Buscar "paper texture generator" o "seamless noise texture"
2. Configurar: subtle, 512x512, seamless
3. Descargar PNG

**Método C: Con IA (Midjourney/Stable Diffusion)**
Prompt: 
```
seamless paper texture, subtle grain, kraft paper, minimalist, tileable, 
neutral gray, high resolution, no text, uniform lighting
```

### Paso 3: Añadir a Xcode

1. Guarda la imagen como `paper-grain.png`
2. Arrastra al Image Set `PaperGrain` en Assets.xcassets
3. En el Inspector (panel derecho):
   - **Render As:** Default
   - **Resizing:** Tile

---

## OPCIÓN 3: Usar textura por código (sin asset)

Si prefieres NO usar Assets, puedes generar la textura programáticamente:

```swift
// En BitacoraApp.swift, reemplazar:
Theme.paperGrainTexture
    .resizable(resizingMode: .tile)

// Por:
Image(systemName: "circle.grid.cross.fill")
    .resizable(resizingMode: .tile)
    .foregroundStyle(.gray)
    .opacity(0.02)
```

Esto usa un patrón de SF Symbols como textura simple.

---

## 🎨 Ajustar opacidad después

Si la textura es muy visible o muy invisible, edita en `BitacoraApp.swift`:

```swift
// Línea actual:
static let paperGrainOpacity: Double = 0.06

// Probar valores:
0.03 // Muy sutil (casi invisible)
0.06 // Sutil (recomendado)
0.10 // Visible
0.15 // Muy visible
```

---

## ✅ Verificación

Para ver la textura funcionando:

1. Ejecuta la app (Cmd + R)
2. Mira el fondo general
3. Debe verse un grano muy sutil sobre el fondo crema/kraft
4. Si no ves nada, aumenta `paperGrainOpacity` a 0.15

---

## 🚫 Si quieres desactivar la textura temporalmente

En `BitacoraApp.swift`, comenta estas líneas:

```swift
// Theme.paperGrainTexture
//     .resizable(resizingMode: .tile)
//     .blendMode(.multiply)
//     .opacity(Theme.paperGrainOpacity)
//     .ignoresSafeArea()
//     .allowsHitTesting(false)
```

---

## 📦 Textura de ejemplo para testing

Si quieres algo rápido para probar, crea una imagen con este código de Processing/p5.js:

```javascript
function setup() {
  createCanvas(512, 512);
  background(128); // gris medio
  loadPixels();
  for (let i = 0; i < pixels.length; i += 4) {
    let noise = random(-10, 10);
    pixels[i] = 128 + noise;
    pixels[i+1] = 128 + noise;
    pixels[i+2] = 128 + noise;
  }
  updatePixels();
  save('paper-grain.png');
}
```

O simplemente usa una foto de papel real con alta exposición y poco contraste.

---

**Siguiente paso:** Sigue con `VISUAL_REDESIGN_SUMMARY.md` para ver el resumen completo de todos los cambios visuales.
