# ✅ Verificación de Color Sets - Checklist

## Paso 1: Verificar que existen en Assets

En Xcode, abre `Assets.xcassets` y verifica:

```
Assets.xcassets/
└── Colors/
    ├── PaperBackground.colorset
    ├── Accent.colorset
    ├── Ink.colorset
    ├── InkMuted.colorset
    ├── Hairline.colorset
    └── Card.colorset
```

**¿Los 6 están creados?** [ ]

---

## Paso 2: Verificar variantes Light/Dark

Para CADA color set, haz clic en él y verifica en el Inspector (panel derecho):

### PaperBackground
- [ ] Tiene variante "Any Appearance" (Light)
- [ ] Tiene variante "Dark"
- [ ] Light: #F5F1E8 (RGB: 245, 241, 232)
- [ ] Dark: #3A3530 (RGB: 58, 53, 48)

### Accent
- [ ] Tiene variante "Any Appearance" (Light)
- [ ] Tiene variante "Dark"
- [ ] Light: #7A8B6F (RGB: 122, 139, 111)
- [ ] Dark: #8A9B7F (RGB: 138, 155, 127)

### Ink
- [ ] Tiene variante "Any Appearance" (Light)
- [ ] Tiene variante "Dark"
- [ ] Light: #2C2A26 (RGB: 44, 42, 38)
- [ ] Dark: #E8E4DC (RGB: 232, 228, 220)

### InkMuted
- [ ] Tiene variante "Any Appearance" (Light)
- [ ] Tiene variante "Dark"
- [ ] Light: #6B6762 (RGB: 107, 103, 98)
- [ ] Dark: #A8A39E (RGB: 168, 163, 158)

### Hairline
- [ ] Tiene variante "Any Appearance" (Light)
- [ ] Tiene variante "Dark"
- [ ] Light: #D9D5CD (RGB: 217, 213, 205)
- [ ] Dark: #4A4540 (RGB: 74, 69, 64)

### Card
- [ ] Tiene variante "Any Appearance" (Light)
- [ ] Tiene variante "Dark"
- [ ] Light: #FAF8F3 (RGB: 250, 248, 243)
- [ ] Dark: #3F3A35 (RGB: 63, 58, 53)

---

## Paso 3: Verificar que no hay errores de compilación

1. **Clean Build Folder:**
   - Cmd + Shift + K

2. **Build:**
   - Cmd + B

3. **Verificar errores:**
   - [ ] NO aparece "Cannot find 'PaperBackground' in asset catalog"
   - [ ] NO aparece "Cannot find 'Accent' in asset catalog"
   - [ ] NO aparece "Cannot find 'Ink' in asset catalog"
   - [ ] NO aparece "Cannot find 'InkMuted' in asset catalog"
   - [ ] NO aparece "Cannot find 'Hairline' in asset catalog"
   - [ ] NO aparece "Cannot find 'Card' in asset catalog"

---

## Paso 4: Test visual rápido

He creado un archivo `ColorTestView.swift` para probar.

1. **Añádelo temporalmente a tu proyecto:**
   - Arrastra `ColorTestView.swift` al proyecto
   
2. **Previsualiza:**
   - Abre el archivo
   - Activa Preview (Canvas, Cmd + Option + Enter)
   
3. **Verifica:**
   - [ ] Los 6 colores se muestran sin error
   - [ ] PaperBackground es crema/beige claro
   - [ ] Accent es verde salvia apagado
   - [ ] Ink es marrón oscuro
   - [ ] InkMuted es marrón grisáceo
   - [ ] Hairline es casi invisible (beige claro)
   - [ ] Card es crema muy claro

4. **Cambia a Dark Mode:**
   - En el Preview, cambiar a Dark Appearance
   
5. **Verifica:**
   - [ ] PaperBackground es marrón oscuro
   - [ ] Accent es verde salvia más claro
   - [ ] Ink es crema/beige claro (invertido)
   - [ ] InkMuted es marrón claro
   - [ ] Hairline es gris oscuro
   - [ ] Card es marrón oscuro (un poco más claro que Paper)

---

## Paso 5: Ejecutar la app

1. **Run en simulador:**
   - Cmd + R

2. **Primera verificación (Light Mode):**
   - [ ] Fondo general es crema/kraft (no verde-gris)
   - [ ] Texto principal es marrón oscuro (no verde-negro)
   - [ ] Accent (badges, iconos) es verde salvia (no verde azulado)
   - [ ] Bordes son sutiles, casi invisibles

3. **Cambiar a Dark Mode:**
   - Simulador > Features > Toggle Appearance
   - O: Settings > Developer > Dark Appearance

4. **Segunda verificación (Dark Mode):**
   - [ ] Fondo es marrón oscuro cálido (no negro ni gris frío)
   - [ ] Texto es crema/beige claro
   - [ ] Accent es verde salvia más claro
   - [ ] Se siente como "papel envejecido" (no pantalla oscura)

---

## 🚨 Problemas comunes

### Error: "Cannot find color in asset catalog"

**Causa:** El nombre del Color Set no coincide exactamente.

**Solución:**
1. Verifica que los nombres sean EXACTAMENTE:
   - `PaperBackground` (con mayúscula P y B)
   - `Accent` (con mayúscula A)
   - `Ink` (con mayúscula I)
   - `InkMuted` (con mayúsculas I y M)
   - `Hairline` (con mayúscula H)
   - `Card` (con mayúscula C)

2. NO debe haber espacios ni guiones

---

### Error: "Color appears as black/white"

**Causa:** No configuraste la variante Dark o los valores RGB están mal.

**Solución:**
1. Haz clic en el Color Set
2. Inspector > Appearances > debe decir "Any, Dark"
3. Si solo dice "Any", añade Dark con el botón "+"
4. Verifica los valores RGB en cada variante

---

### Los colores se ven pero no cambian en Dark Mode

**Causa:** Falta la variante Dark.

**Solución:**
1. Para CADA color set:
2. Inspector > Appearances > "+" > Dark
3. Configura los valores Dark

---

### Error: "The data couldn't be read because it isn't in the correct format"

**Causa:** El archivo .colorset está corrupto.

**Solución:**
1. Borra el color set problemático
2. Créalo de nuevo desde cero
3. New Color Set > renombrar > configurar valores

---

## ✅ Todo correcto si:

- [ ] Los 6 Color Sets existen
- [ ] Cada uno tiene Light y Dark
- [ ] La app compila sin errores
- [ ] Los colores se ven cálidos (no fríos)
- [ ] Dark Mode funciona
- [ ] No hay warnings de "color not found"

---

## 🎯 Si todo está bien

**Elimina el archivo de test:**
```
ColorTestView.swift
```

Y continúa con:
```
PAPER_TEXTURE_INSTRUCTIONS.md
```

Para añadir la textura de papel.

---

**¿Pasaron todos los checks?** Dime si encuentras algún problema y te ayudo a solucionarlo. 🎨✨
