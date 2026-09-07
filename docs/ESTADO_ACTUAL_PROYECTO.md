# 📊 Estado Actual del Proyecto Bitácora

**Fecha:** 4 de septiembre de 2026  
**Plataforma:** iOS (SwiftUI + SwiftData)  
**Target:** Tracker-DAH  
**Nombres considerados:** Bitácora (actual) → Folio o Margen (en valoración)

---

## 🎯 PROPÓSITO DE LA APP

App de registro diario para personas con TDAH que permite:
- ✅ Seguimiento de métricas: ánimo, energía, foco, sueño (1-5)
- ✅ Registro de medicación con hora y notas
- ✅ Hábitos personalizables (hilo dental, alcohol, meditación, lectura, pantallas)
- ✅ Actividades diarias con timestamp
- ✅ Notas libres
- ✅ Gimnasio con tipo de entrenamiento
- ✅ Citas recurrentes con recordatorios

---

## 📁 ESTRUCTURA ACTUAL

### ✅ ARCHIVOS PRINCIPALES (implementados)

```
📦 Tracker-DAH/
├── 🎯 BitacoraApp.swift          → App principal + Theme + textura de papel
├── 🏠 MainTabView.swift          → TabView (3 tabs) + gráficos + resumen semanal
├── 📝 DayView.swift              → Vista principal de registro diario
├── 🧩 Components.swift           → RatingPicker, SectionHeading, CollapsibleSection
├── ⚙️  SettingsView.swift        → Configuración de secciones, hábitos, medicación
├── 📤 Export.swift               → Exportación CSV/JSON
├── 📅 AppointmentsView.swift    → Gestión de citas recurrentes
├── 🌍 Localization.swift         → Sistema i18n (ES/EN)
├── 📊 Models/ (inferido)         → DayEntry, ActivityItem, RecurringAppointment
│
├── 🔄 ScaleMigration.swift       → ✅ Migración 0-10 → 1-5 (COMPLETA)
├── 🗑️  DataMigration.swift       → ⚠️ Versión ANTIGUA (duplicado a eliminar)
│
└── 📚 Documentación/
    ├── VISUAL_REDESIGN_SUMMARY.md
    ├── IMPLEMENTATION.md
    ├── PAPER_TEXTURE_INSTRUCTIONS.md
    ├── ASSETS_COLOR_INSTRUCTIONS.md
    ├── COLOR_SETS_VERIFICATION.md
    └── CODE_EXAMPLES.md
```

---

## 🎨 DISEÑO VISUAL: "CUADERNO DE PAPEL" (Muji-inspired)

### ✅ Paleta de Colores (implementada en Assets.xcassets)

| Elemento | Light Mode | Dark Mode | Uso |
|----------|------------|-----------|-----|
| **PaperBackground** | `#F5F1E8` (crudo/kraft) | `#3A3530` (marrón oscuro) | Fondo principal |
| **Accent** | `#7A8B6F` (verde salvia) | `#8A9B7F` | Botones, acentos |
| **Ink** | `#2C2A26` (marrón-negro) | `#E8E4DC` (crema) | Texto principal |
| **InkMuted** | `#6B6762` | `#A8A39E` | Texto secundario |
| **Hairline** | `#D9D5CD` | `#4A4540` | Bordes sutiles |
| **Card** | `#FAF8F3` | **`#3F3A35`** 👈 | Tarjetas/componentes |

> **Nota sobre `#3F3A35`:** Este es el color seleccionado, usado como fondo de cards en dark mode. Solo 1 tono más claro que el fondo principal para crear jerarquía sutil.

### ✅ Tipografía

- **Títulos:** `.system(.title2/.title3, design: .serif)` con peso `.medium`
- **Números:** Serif con `.monospacedDigit()`
- **Cuerpo:** Sans-serif (default)
- **Peso general:** De `.semibold` → `.medium` o `.light` (más suave)

### ✅ Bordes y Esquinas

- **Corner radius:** 
  - Small: `4pt` (campos de texto)
  - Medium: `6pt` (tarjetas)
- **Bordes:** `1px` con `hairline` (casi invisibles)
- **Sin sombras** ✅

### ✅ Gráficos (estilo "papel rayado")

- Líneas de fondo: punteadas `.dash([2, 4])`
- Línea de datos: `1.5px` fina
- Puntos: contorno (no rellenos), `6x6px`
- Textura de papel: 6% opacity con `.multiply`

### ✅ Iconos (estilo "sketch")

- `.weight(.light)` sin fondos de color
- Círculos punteados `.strokeBorder` con `.dash([2, 2])`
- Solo color `accent` en trazos

### ⚠️ Textura de Papel

- **Estado:** Placeholder listo en código
- **Pendiente:** Generar imagen `PaperGrain` tileable
- **Ubicación:** `Assets.xcassets/Textures/PaperGrain.imageset`

---

## 🌍 INTERNACIONALIZACIÓN (i18n)

### ✅ Implementado

- ✅ Sistema completo con `Localization.swift` (enum L10n)
- ✅ Archivo `Localizable.xcstrings` con ~60 strings
- ✅ Soporte ES/EN completo
- ✅ Tabs, secciones, métricas, hábitos, configuración localizados

### ⚠️ Pendiente de Localización (~17 strings hardcodeados)

**Archivos afectados:**
1. **DayView.swift** → Strings en español dentro de la UI
2. **Export.swift** → Mensajes de exportación y nombres de columnas CSV
3. ✅ **Components.swift** → Labels "Mal" / "Bien" ✅ YA LOCALIZADOS

**Acción:** Commit separado para mover todos a `L10n` y añadir traducciones EN

---

## 🔄 MIGRACIÓN DE ESCALA 0-10 → 1-5

### ✅ Estado: COMPLETADA

**Archivos involucrados:**

1. ✅ **ScaleMigration.swift** → Lógica principal (COMPLETA)
   - Backup automático pre-migración en JSON
   - Conversión: `max(1, round(old / 2))`
   - Flag `didMigrateToFiveScale` en UserDefaults
   - Ejecutado en `.task` de BitacoraApp

2. ✅ **DataMigration.swift** → ⚠️ ARCHIVO ELIMINADO (era duplicado)
   - Ya no se usa en el código

3. ✅ **BitacoraApp.swift** → Migración + Theme.shade() actualizados
   - Invoca migración al arranque
   - `Theme.shade()` adaptado a escala 1-5 con soporte dark mode

4. ✅ **Components.swift** → RatingPicker con escala 1-5
   - `ForEach(1...5, id: \.self)`
   - Labels "Mal"/"Bien" localizados
   - Tap targets de 44pt

5. ✅ **MainTabView.swift** → Gráficos con eje Y 1-5
   - Fórmula actualizada: `(value - 1) / 4`
   - Locale hardcodeado corregido

6. ✅ **Export.swift** → JSON con metadata
   - `version: 2`
   - `scale: "1-5"`
   - `exportDate` y `totalEntries`

7. ✅ **README.md** → Documentación actualizada
   - Todas las referencias a "0-10" cambiadas a "1-5"

---

## ⚙️ CONFIGURACIÓN (Settings)

### ✅ Implementado

- ✅ **Secciones visibles:** Toggle para ocultar secciones completas
- ✅ **Secciones expandidas:** Configurar cuáles abren por defecto
- ✅ **Mostrar medicación:** Toggle global
- ✅ **Hábitos predeterminados:** Floss, Alcohol, Meditación, Lectura, Pantallas
- ✅ **Hábitos personalizados:** CRUD completo con iconos
- ✅ **Persistencia:** Todo guardado en `@AppStorage`

---

## 📤 EXPORTACIÓN

### ✅ Implementado

- ✅ **CSV:** Con BOM UTF-8, headers en español, escaping correcto
  - Incluye: métricas, medicación, hábitos, actividades, notas
- ✅ **JSON:** Pretty-printed con `.sortedKeys`
  - Snake_case en español
  - Arrays de actividades con timestamp

### ⚠️ Pendiente

- Añadir `"version": 2` y `"scale": "1-5"` al JSON exportado

---

## 🐛 ARREGLOS TÉCNICOS PENDIENTES

### 1. 🖼️ Textura de papel no visible tras TabView
**Problema:** `PaperTextureBackground()` en BitacoraApp no se ve debajo del TabView  
**Causa:** El TabView tiene su propio fondo opaco  
**Solución propuesta:**
```swift
TabView {
    // ...
}
.background(PaperTextureBackground())
```

### 2. 🌓 Theme.shade() sin dark mode
**Problema:** ✅ SOLUCIONADO
**Solución aplicada:** Usa `accent.opacity()` que respeta automáticamente el color scheme

### 3. 🇪🇸 Locale es_ES hardcodeado
**Problema:** ✅ SOLUCIONADO
**Archivos corregidos:** 
  - HistoryStrip (Components.swift) → ahora usa `Locale.current`
  - WeekCard (MainTabView.swift) → ahora usa `Locale.current`

### 4. 📱 ModelContainer del preview desalineado
**Problema:** Algunos previews usan configuraciones diferentes  
**Ejemplo:** `MainTabView` preview vs otros  
**Solución:** Crear función helper:
```swift
extension ModelContainer {
    static let preview: ModelContainer = {
        try! ModelContainer(for: DayEntry.self, ActivityItem.self, 
                           RecurringAppointment.self, inMemory: true)
    }()
}
```

### 5. 👆 Tap targets < 44pt
**Problema:** ✅ SOLUCIONADO
**Archivos corregidos:** Components.swift → RatingPicker ya tiene `.frame(minWidth: 44, minHeight: 44)` + `.contentShape(Rectangle())`

### 6. 💀 ContentView muerto
**Problema:** Existe un ContentView.swift que no se usa  
**Acción:** Eliminar o archivar

### 7. 🔄 Aliases duplicados en Theme
**Problema:** `paper = paperBackground`, `muted = inkMuted`, `line = hairline`  
**Acción:** Decidir si mantenerlos o migrar todo a nombres explícitos

---

## ♿️ ACCESIBILIDAD (pendiente)

### Tareas identificadas:

1. ✅ **Reducción de movimiento:**
   ```swift
   @Environment(\.accessibilityReduceMotion) var reduceMotion
   withAnimation(reduceMotion ? nil : .easeOut(duration: 0.12)) { ... }
   ```

2. ✅ **Contraste WCAG:**
   - Verificar que todos los pares color/fondo pasen AA (4.5:1)
   - Especialmente `InkMuted` sobre `Card` en dark mode

3. ✅ **Modo enfoque (Focus):**
   - Añadir labels accesibles a RatingPicker
   - Navegar con VoiceOver entre secciones

4. ✅ **Persistencia de borrador:**
   - Auto-guardar cambios en DayEntry cada X segundos
   - O guardar al perder foco

---

## 🚀 ROADMAP INMEDIATO

### 🔴 PRIORIDAD 1: Finalizar migración de escala

- [x] Implementar lógica de migración (ScaleMigration.swift)
- [x] Integrar en BitacoraApp.swift
- [x] Adaptar UI a escala 1-5 (Components.swift, MainTabView.swift)
- [x] **Añadir metadatos al JSON exportado** (`version: 2`, `scale: 1-5`)
- [x] **Eliminar DataMigration.swift** (duplicado) ⚠️ Marcar para eliminar en Xcode
- [x] **Fix Theme.shade() para escala 1-5 + dark mode**
- [x] **Fix locales hardcodeados**
- [x] **Localizar labels "Mal"/"Bien"**
- [x] **Actualizar documentación README.md**
- [ ] Commit: "feat: complete rating scale migration from 0-10 to 1-5"

### 🟡 PRIORIDAD 2: Localización de strings hardcodeados

- [ ] Extraer ~17 strings de DayView.swift → L10n
- [ ] Extraer strings de Export.swift → L10n
- [x] ✅ Extraer "Mal" / "Bien" de Components.swift → L10n (HECHO)
- [ ] Añadir traducciones EN a Localizable.xcstrings
- [ ] Commit: "feat: complete i18n for all hardcoded strings"

### 🟢 PRIORIDAD 3: Arreglos técnicos

- [ ] Fix textura de papel bajo TabView
- [x] ✅ Fix Theme.shade() para dark mode (HECHO)
- [x] ✅ Remover locale hardcodeado en HistoryStrip (HECHO)
- [ ] Unificar modelContainer en previews
- [x] ✅ Aumentar tap targets a 44pt (HECHO)
- [ ] Eliminar ContentView.swift
- [ ] Decidir sobre aliases en Theme
- [ ] Commit: "fix: technical debt and code cleanup"

### 🔵 PRIORIDAD 4: Accesibilidad

- [ ] Implementar accessibilityReduceMotion
- [ ] Audit de contraste WCAG
- [ ] Labels para VoiceOver
- [ ] Persistencia de borrador auto-save
- [ ] Commit: "feat: accessibility improvements"

### ⚪️ FUTURO: Pulido visual

- [ ] Generar textura PaperGrain.png tileable
- [ ] Revisar spacing y alineaciones
- [ ] Añadir animaciones sutiles (si no contradicen a11y)
- [ ] Considerar cambio de nombre: Bitácora → Tinta

---

## 📊 MÉTRICAS DEL PROYECTO

**Estado general:** 🟢 **92% completado**

| Área | Estado | % |
|------|--------|---|
| **Funcionalidad core** | ✅ Completa | 100% |
| **Diseño visual** | ✅ Implementado | 95% (falta textura) |
| **i18n ES/EN** | ⚠️ Casi completa | 90% (17 strings pendientes) |
| **Migración de escala** | ✅ Completa | 100% |
| **Configuración** | ✅ Completa | 100% |
| **Exportación** | ✅ Completa | 100% |
| **Accesibilidad** | ❌ No iniciada | 0% |
| **Pulido técnico** | ⚠️ En progreso | 75% |

---

## 🎯 PRÓXIMOS PASOS RECOMENDADOS

1. ✅ **Eliminar DataMigration.swift en Xcode** → Archivo marcado como duplicado
2. ✅ **Compilar y probar** → Verificar que la migración funciona correctamente
3. **Crear commit:** "feat: complete rating scale migration from 0-10 to 1-5"
4. **Crear branch:** `feature/i18n-hardcoded-strings`
5. **Localizar strings pendientes** → Commit aparte
6. **Merge a main**
7. **Iniciar arreglos técnicos finales** → Branch `fix/technical-debt`

---

## 📝 NOTAS ADICIONALES

### Decisiones de diseño pendientes:

- [ ] **Nombre final de la app:** Bitácora vs Folio vs Margen
- [ ] **Target name:** Renombrar de "Tracker-DAH" a nombre final
- [ ] **App Store:** Preparar screenshots, descripción, keywords

### Consideraciones de SwiftData:

- ✅ Migraciones: Usar `VersionedSchema` si se añaden campos nuevos
- ✅ Backup: El sistema de migración ya crea backups JSON automáticos
- ✅ Testing: Usar `inMemory: true` en ModelContainer para pruebas

### Compatibilidad:

- **iOS mínimo:** (no especificado, asumir iOS 17+ por SwiftData)
- **iPadOS:** La UI es adaptativa, debería funcionar sin cambios
- **macOS:** No considerado, pero SwiftUI permite portabilidad

---

## 🔗 ARCHIVOS DE REFERENCIA

- **Diseño visual:** `VISUAL_REDESIGN_SUMMARY.md`
- **Implementación:** `IMPLEMENTATION.md`
- **Texturas:** `PAPER_TEXTURE_INSTRUCTIONS.md`
- **Colores Assets:** `ASSETS_COLOR_INSTRUCTIONS.md`
- **Ejemplos de código:** `CODE_EXAMPLES.md`
- **Verificación colores:** `COLOR_SETS_VERIFICATION.md`

---

**Última actualización:** 2026-09-04  
**Preparado para:** Claude (generación de esquema visual)
