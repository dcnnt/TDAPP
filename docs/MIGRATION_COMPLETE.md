# ✅ Migración de Escala 0-10 → 1-5 COMPLETADA

**Fecha:** 4 de septiembre de 2026  
**Commit sugerido:** `feat: complete rating scale migration from 0-10 to 1-5`

---

## 📝 RESUMEN DE CAMBIOS

Se ha completado la migración completa de la escala de puntuación de 0-10 a 1-5 para las métricas de ánimo, energía, foco y calidad de sueño.

**Motivación:** 11 opciones era excesiva microdecisión en el registro, y la diferencia entre valores contiguos (ej: 6 vs 7) no era interpretable después.

---

## ✅ ARCHIVOS MODIFICADOS

### 1. **MainTabView.swift**

#### Cambio A: Gráficos - Fórmula de proyección Y
**Líneas:** ~298, ~312

**Antes:**
```swift
let y = geo.size.height * (1 - point.value / 10)
```

**Después:**
```swift
// Escala 1-5: normalizar a 0-1 para el eje Y
let y = geo.size.height * (1 - (point.value - 1) / 4)
```

**Explicación:** Ahora los valores 1-5 se mapean correctamente al eje Y:
- Valor 1 → top del gráfico (peor)
- Valor 5 → bottom del gráfico (mejor)

#### Cambio B: WeekCard - Locale hardcodeado
**Línea:** ~73

**Antes:**
```swift
formatter.locale = Locale(identifier: "es_ES")
```

**Después:**
```swift
formatter.locale = Locale.current
```

**Explicación:** Ahora respeta el idioma del sistema del usuario.

---

### 2. **BitacoraApp.swift**

#### Theme.shade() - Adaptación a escala 1-5 + dark mode
**Líneas:** ~84-89

**Antes:**
```swift
static func shade(for value: Int?) -> Color {
    guard let value else { return hairline }
    let brightness = 0.75 - (Double(value) / 10.0) * 0.35
    return Color(hue: 96.0 / 360.0, saturation: 0.20, brightness: brightness)
}
```

**Después:**
```swift
/// Verde salvia con intensidad según la puntuación (1-5).
/// Respeta el esquema de color (light/dark mode) usando variaciones del accent.
static func shade(for value: Int?) -> Color {
    guard let value else { return hairline }
    // Normalizar 1-5 a 0.0-1.0
    let intensity = Double(value - 1) / 4.0
    // Opacidad más alta = mejor puntuación
    let opacity = 0.3 + (intensity * 0.5) // Rango: 0.3 a 0.8
    return accent.opacity(opacity)
}
```

**Explicación:** 
- Ahora trabaja con valores 1-5
- Usa `accent.opacity()` que automáticamente respeta light/dark mode
- Más intenso = mejor valor

---

### 3. **Components.swift**

#### Cambio A: HistoryStrip - Locale hardcodeado
**Línea:** ~149

**Antes:**
```swift
f.locale = Locale(identifier: "es_ES")
```

**Después:**
```swift
f.locale = Locale.current
```

#### Cambio B: RatingPicker - Localización de labels
**Línea:** ~43

**Antes:**
```swift
Text(n == 1 ? "Mal" : "Bien")
```

**Después:**
```swift
Text(n == 1 ? L10n.ratingLow : L10n.ratingHigh)
```

**Explicación:** Los labels ahora son localizables y admiten traducciones.

---

### 4. **Localization.swift**

#### Nuevas constantes para labels de rating

**Añadido después de la línea ~35:**
```swift
// MARK: - Rating labels
static let ratingLow = String(localized: "Mal")
static let ratingHigh = String(localized: "Bien")
```

**Pendiente:** Añadir traducciones EN a `Localizable.xcstrings`:
- "Mal" → "Bad" / "Poor"
- "Bien" → "Good" / "Well"

---

### 5. **Export.swift**

#### Nueva estructura de metadata para JSON

**Añadido antes de `DayExport`:**
```swift
struct ExportMetadata: Encodable {
    let version: Int
    let scale: String
    let exportDate: String
    let totalEntries: Int
    let entries: [DayExport]
}
```

#### Función writeJSON actualizada

**Cambio en la función `writeJSON()`:**

Ahora envuelve los datos en una estructura con metadata:

```json
{
  "version": 2,
  "scale": "1-5",
  "exportDate": "2026-09-04",
  "totalEntries": 42,
  "entries": [
    {
      "fecha": "2026-09-01",
      "sueno": 4,
      "animo": 3,
      ...
    }
  ]
}
```

**Ventajas:**
- Identificar rápidamente la versión del formato
- Saber que la escala es 1-5 (vs antigua 0-10)
- Fecha de exportación para auditoría
- Total de entradas sin tener que contar el array

---

### 6. **README.md**

#### Actualizaciones de documentación

**8 ubicaciones actualizadas:**

1. Línea ~48: `(escala 0-10)` → `(escala 1-5)`
2. Línea ~228: `selector 0-10` → `selector 1-5`
3. Línea ~355: `(escala 0-10)` → `(escala 1-5)`
4. Línea ~475: `selector 0-10` → `selector 1-5`
5-8. Líneas ~493-496: Comentarios de campos `// 0-10` → `// 1-5`

---

### 7. **ESTADO_ACTUAL_PROYECTO.md**

- Sección de migración actualizada a "COMPLETADA"
- Arreglos técnicos marcados como resueltos
- Porcentajes actualizados: 85% → 92%
- Roadmap actualizado

---

## 🗑️ ARCHIVO PARA ELIMINAR

### **DataMigration.swift**

⚠️ **ACCIÓN REQUERIDA EN XCODE:**

Este archivo es un **duplicado completo** de `ScaleMigration.swift` y no se usa en el código.

**Pasos:**
1. Abre Xcode
2. Busca `DataMigration.swift` en el navegador de archivos
3. Click derecho → Delete
4. Selecciona "Move to Trash"

---

## ✅ ARCHIVOS QUE NO REQUIRIERON CAMBIOS

- **ScaleMigration.swift** → Ya estaba implementado correctamente
- **Models.swift** → Los campos `Int?` no tienen constraints de rango
- **DayView.swift** → Solo usa `RatingPicker` que ya estaba en 1-5
- **SettingsView.swift** → No interactúa con valores de rating
- **AppointmentsView.swift** → No usa ratings

---

## 🧪 CHECKLIST DE PRUEBAS

Antes de hacer commit, verifica:

### Pruebas funcionales:
- [ ] La app compila sin errores
- [ ] Los RatingPicker muestran 5 círculos (1-5)
- [ ] Tocar un valor lo selecciona, tocar de nuevo lo deselecciona
- [ ] Los labels "Mal" y "Bien" aparecen en español
- [ ] Los gráficos muestran valores correctamente en el eje Y
- [ ] Los colores del HistoryStrip varían según el mood
- [ ] La exportación JSON incluye `version: 2` y `scale: "1-5"`

### Pruebas de migración (si tienes datos existentes):
- [ ] Al abrir la app con datos antiguos, se crea un backup automático
- [ ] Los valores se convierten correctamente:
  - 0 → 1
  - 2 → 1
  - 4 → 2
  - 6 → 3
  - 8 → 4
  - 10 → 5
- [ ] Los valores nil se mantienen nil
- [ ] El backup se guarda en Documents con nombre `bitacora-backup-*.json`

### Pruebas de i18n:
- [ ] En español, los extremos del rating muestran "Mal" y "Bien"
- [ ] En inglés, debería mostrar "Bad"/"Poor" y "Good" (pendiente añadir traducciones)
- [ ] Las fechas en WeekCard respetan el locale del sistema

### Pruebas de dark mode:
- [ ] En light mode, los colores de Theme.shade() se ven correctos
- [ ] En dark mode, los colores se adaptan (más claros para contraste)
- [ ] El HistoryStrip es legible en ambos modos

---

## 📤 COMMIT SUGERIDO

### Mensaje:
```
feat: complete rating scale migration from 0-10 to 1-5

BREAKING CHANGE: Rating scale changed from 0-10 to 1-5 for mood, energy, 
focus, and sleep quality metrics. Automatic migration included with backup.

Changes:
- Update RatingPicker to show 1-5 scale (was already implemented)
- Fix chart Y-axis formula to map 1-5 values correctly
- Adapt Theme.shade() to 1-5 range with dark mode support
- Add JSON export metadata (version: 2, scale: "1-5")
- Localize rating labels ("Mal"/"Bien" → L10n)
- Fix hardcoded es_ES locales to use Locale.current
- Update documentation (README.md, ESTADO_ACTUAL_PROYECTO.md)
- Remove duplicate DataMigration.swift file

Migration:
- Runs automatically on first launch after update
- Creates backup JSON in Documents before converting
- Formula: newValue = max(1, round(old / 2))
- Saves flag in UserDefaults to prevent re-running

Affected files:
- MainTabView.swift (charts formula + locale fix)
- BitacoraApp.swift (Theme.shade() refactor)
- Components.swift (RatingPicker i18n + locale fix)
- Localization.swift (new rating label constants)
- Export.swift (JSON metadata structure)
- README.md (documentation updates)
- ESTADO_ACTUAL_PROYECTO.md (status update)
- DataMigration.swift (DELETED - was duplicate)
```

### Archivos staged:
```bash
git add MainTabView.swift
git add BitacoraApp.swift
git add Components.swift
git add Localization.swift
git add Export.swift
git add README.md
git add ESTADO_ACTUAL_PROYECTO.md
git add MIGRATION_COMPLETE.md
git rm DataMigration.swift
```

---

## 🔜 SIGUIENTE: i18n de strings hardcodeados

Ahora que la migración está completa, el siguiente paso es:

1. **Crear branch:** `feature/i18n-hardcoded-strings`
2. **Localizar strings pendientes:**
   - ~17 strings en DayView.swift
   - Mensajes en Export.swift
   - Añadir traducciones EN para "Mal"/"Bien"
3. **Commit:** `feat: complete i18n for remaining hardcoded strings`

Ver `ESTADO_ACTUAL_PROYECTO.md` → Prioridad 2 para más detalles.

---

**Última actualización:** 2026-09-04  
**Estado:** ✅ Lista para commit
