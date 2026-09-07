# 💻 Ejemplos de Código - Localización

## 📖 Cómo usar L10n en el código

### Antes (hardcoded):
```swift
Text("Configuración")
```

### Ahora (localizado):
```swift
Text(L10n.settings)
```

**Resultado:**
- iPhone en español: "Configuración"
- iPhone en inglés: "Settings"

---

## 🎯 Ejemplos completos

### 1. Tabs principales

```swift
// MainTabView.swift
TabView {
    DayView()
        .tabItem {
            Label(L10n.tabJournal, systemImage: "book.fill")
            // ES: "Bitácora"
            // EN: "Journal"
        }
    
    WeeklySummaryView()
        .tabItem {
            Label(L10n.tabSummary, systemImage: "calendar")
            // ES: "Resumen"
            // EN: "Summary"
        }
    
    ChartsView()
        .tabItem {
            Label(L10n.tabCharts, systemImage: "chart.line.uptrend.xyaxis")
            // ES: "Gráficas"
            // EN: "Charts"
        }
}
```

### 2. Navigation titles

```swift
// DayView.swift
NavigationStack {
    // ...
}
.navigationTitle(L10n.tabJournal)
// ES: "Bitácora"
// EN: "Journal"

// SettingsView.swift
NavigationStack {
    // ...
}
.navigationTitle(L10n.settings)
// ES: "Configuración"
// EN: "Settings"
```

### 3. Botones

```swift
// Botón "Listo"
Button(L10n.done) {
    dismiss()
}
// ES: "Listo"
// EN: "Done"

// Botón "Hoy"
Button(L10n.today) {
    selectedDate = Date()
}
// ES: "Hoy"
// EN: "Today"

// Botón "Añadir"
Button(L10n.add) {
    addItem()
}
// ES: "Añadir"
// EN: "Add"
```

### 4. Secciones colapsables

```swift
// DayView.swift
CollapsibleSection(
    title: L10n.sectionSleep,
    // ES: "Sueño y medicación"
    // EN: "Sleep & Medication"
    systemImage: "moon.stars.fill",
    isExpanded: $expandedSleep,
    badge: badgeForSleep
) {
    sleepAndMeds
}

CollapsibleSection(
    title: L10n.sectionFeelings,
    // ES: "Cómo te sientes"
    // EN: "How You Feel"
    systemImage: "heart.fill",
    isExpanded: $expandedFeelings,
    badge: badgeForFeelings
) {
    feelings
}
```

### 5. Labels de campos

```swift
// DayView.swift - Sueño y medicación
optionalTimeRow(label: L10n.wakeTime, keyPath: \.wakeTime)
// ES: "Hora de despertar"
// EN: "Wake time"

RatingPicker(label: L10n.sleepQuality, value: bindOptional(\.sleep))
// ES: "Calidad del sueño"
// EN: "Sleep quality"

optionalTimeRow(label: L10n.medicationTime, keyPath: \.medTime)
// ES: "Hora de la medicación"
// EN: "Medication time"

Text(L10n.medicationNotes).font(.subheadline)
// ES: "Notas sobre la medicación"
// EN: "Medication notes"
```

### 6. Métricas (Ánimo, Energía, Foco)

```swift
// DayView.swift - Feelings section
RatingPicker(label: L10n.mood, value: bindOptional(\.mood))
// ES: "Ánimo"
// EN: "Mood"

RatingPicker(label: L10n.energy, value: bindOptional(\.energy))
// ES: "Energía"
// EN: "Energy"

RatingPicker(label: L10n.focus, value: bindOptional(\.focus))
// ES: "Foco"
// EN: "Focus"
```

### 7. Hábitos

```swift
// DayView.swift - Habits section
ToggleRow(label: L10n.floss, isOn: bind(\.floss, false))
// ES: "Hilo dental"
// EN: "Dental floss"

ToggleRow(label: L10n.alcohol, isOn: bind(\.alcohol, false)) {
    PlainTextField(placeholder: "¿Qué y cuánto?", text: bind(\.alcoholDetail, ""))
}
// ES: "Alcohol"
// EN: "Alcohol" (igual)

ToggleRow(label: L10n.meditation, isOn: bind(\.meditated, false)) {
    MinutesField(placeholder: "Minutos", minutes: bindOptional(\.meditationMinutes))
}
// ES: "Meditación"
// EN: "Meditation"

ToggleRow(label: L10n.reading, isOn: bind(\.didRead, false)) {
    MinutesField(placeholder: "Minutos", minutes: bindOptional(\.readingMinutes))
}
// ES: "Lectura"
// EN: "Reading"

ToggleRow(label: L10n.screens, isOn: bind(\.screensBeforeBed, false)) {
    MinutesField(placeholder: "Minutos", minutes: bindOptional(\.screenMinutes))
}
// ES: "Pantallas antes de dormir"
// EN: "Screens before bed"
```

### 8. Configuración (Settings)

```swift
// SettingsView.swift
Section {
    Toggle(L10n.sectionSleep, isOn: binding(for: "visibleSleep", default: true))
    // ES: "Sueño y medicación"
    // EN: "Sleep & Medication"
    
    Toggle(L10n.sectionFeelings, isOn: binding(for: "visibleFeelings", default: true))
    // ES: "Cómo te sientes"
    // EN: "How You Feel"
} header: {
    Text(L10n.visibleSections)
    // ES: "Secciones visibles"
    // EN: "Visible Sections"
} footer: {
    Text(L10n.hideSections)
    // ES: "Oculta las secciones que no uses"
    // EN: "Hide sections you don't use"
}
```

### 9. Gráficas (Charts)

```swift
// MainTabView.swift - ChartsView
NavigationStack {
    // ...
}
.navigationTitle(L10n.analysis)
// ES: "Análisis"
// EN: "Analysis"

// Picker de métricas
enum Metric: String, CaseIterable {
    case mood, sleep, energy, focus
    
    var localizedName: String {
        switch self {
        case .mood: return L10n.mood       // ES: "Ánimo" / EN: "Mood"
        case .sleep: return L10n.sleep     // ES: "Sueño" / EN: "Sleep"
        case .energy: return L10n.energy   // ES: "Energía" / EN: "Energy"
        case .focus: return L10n.focus     // ES: "Foco" / EN: "Focus"
        }
    }
}

// Estadísticas
StatCard(title: L10n.average, value: "7.5", icon: "chart.bar.fill")
// ES: "Promedio"
// EN: "Average"

StatCard(title: L10n.maximum, value: "10", icon: "arrow.up.circle.fill")
// ES: "Máximo"
// EN: "Maximum"

StatCard(title: L10n.minimum, value: "3", icon: "arrow.down.circle.fill")
// ES: "Mínimo"
// EN: "Minimum"

// Rachas de hábitos
Text(L10n.habitStreaks)
// ES: "Rachas de hábitos"
// EN: "Habit Streaks"
```

### 10. Mensajes de estado

```swift
// WeeklySummaryView.swift
ContentUnavailableView(
    L10n.noDataYet,
    // ES: "Sin datos todavía"
    // EN: "No data yet"
    systemImage: "calendar.badge.clock",
    description: Text(L10n.startFilling)
    // ES: "Empieza a rellenar tu bitácora diaria"
    // EN: "Start filling your daily journal"
)

// WeekCard.swift
Text(L10n.noNotesWeek)
// ES: "No hay notas esta semana"
// EN: "No notes this week"
```

---

## 🔧 Estructura de Localization.swift

```swift
import Foundation

enum L10n {
    // MARK: - Tabs
    static let tabJournal = String(localized: "Bitácora")
    static let tabSummary = String(localized: "Resumen")
    static let tabCharts = String(localized: "Gráficas")
    
    // MARK: - Sections
    static let sectionSleep = String(localized: "Sueño y medicación")
    static let sectionFeelings = String(localized: "Cómo te sientes")
    static let sectionActivities = String(localized: "Actividades del día")
    static let sectionGym = String(localized: "Gimnasio")
    static let sectionHabits = String(localized: "Hábitos")
    static let sectionNotes = String(localized: "Notas del día")
    
    // ... más constantes
}
```

**Cómo funciona:**
1. `String(localized: "...")` busca la traducción en `Localizable.xcstrings`
2. Si encuentra el idioma del dispositivo, devuelve esa traducción
3. Si no, devuelve el string original (español por defecto)

---

## 🌍 Cómo se ve el Localizable.xcstrings

```json
{
  "sourceLanguage" : "es",
  "strings" : {
    "Bitácora" : {
      "localizations" : {
        "en" : {
          "stringUnit" : {
            "state" : "translated",
            "value" : "Journal"
          }
        }
      }
    },
    "Configuración" : {
      "localizations" : {
        "en" : {
          "stringUnit" : {
            "state" : "translated",
            "value" : "Settings"
          }
        }
      }
    }
  }
}
```

---

## 💡 Buenas prácticas

### ✅ DO (Hacer):

```swift
// Usar L10n para todos los textos visibles
Text(L10n.settings)
Button(L10n.done) { }
.navigationTitle(L10n.analysis)
```

### ❌ DON'T (No hacer):

```swift
// NO hardcodear strings
Text("Configuración")  // ❌ No localizado
Button("Listo") { }    // ❌ No localizado
```

### 🎯 Excepciones (cuando está bien hardcodear):

```swift
// Keys de UserDefaults (no se muestran al usuario)
@AppStorage("expandedSleep") private var expandedSleep = true  // ✅ OK

// Placeholders si son iguales en ambos idiomas
TextField(placeholder: "...", text: $text)  // ✅ OK si es igual

// Números, símbolos
Text("7")   // ✅ OK
Text("✓")   // ✅ OK
```

---

## 🚀 Añadir nuevas traducciones

### Paso 1: Añadir a Localization.swift

```swift
enum L10n {
    // ...
    static let myNewString = String(localized: "Mi nuevo texto")
}
```

### Paso 2: Añadir a Localizable.xcstrings

```json
"Mi nuevo texto" : {
  "localizations" : {
    "en" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "My new text"
      }
    }
  }
}
```

### Paso 3: Usar en el código

```swift
Text(L10n.myNewString)
// ES: "Mi nuevo texto"
// EN: "My new text"
```

---

## 🧪 Probar traducciones

### Método 1: Cambiar idioma del simulador
```
Settings > General > Language & Region > iPhone Language
```

### Método 2: Scheme en Xcode (más rápido)
```
Edit Scheme > Run > Options > App Language > Spanish/English
```

### Método 3: Código temporal (para testing)
```swift
// Solo para probar (NO dejar en producción)
.environment(\.locale, Locale(identifier: "en"))
```

---

## 📊 Cobertura de traducción

### 100% traducido:
- ✅ Tabs principales
- ✅ Navigation titles
- ✅ Nombres de secciones
- ✅ Labels de campos
- ✅ Botones
- ✅ Mensajes de estado
- ✅ Configuración completa
- ✅ Métricas (ánimo, energía, foco, sueño)
- ✅ Hábitos
- ✅ Estadísticas
- ✅ Gráficas

### Pendiente (si se necesita):
- Exportación (CSV/JSON headers)
- Mensajes de error específicos
- Ayuda contextual

---

## 🎓 Recursos para aprender más

### Apple Docs:
- [String Localization](https://developer.apple.com/documentation/xcode/localization)
- [String Catalogs](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog)

### WWDC:
- [WWDC23: Discover String Catalogs](https://developer.apple.com/videos/play/wwdc2023/10155/)

### En este proyecto:
- **LOCALIZATION.md** - Guía de configuración
- **VISUAL_GUIDE.md** - Ejemplos visuales
- **IMPLEMENTATION.md** - Paso a paso completo

---

## ✅ Checklist de localización

Para cada nueva feature:

- [ ] Identificar todos los textos visibles
- [ ] Añadir constantes a `L10n` en `Localization.swift`
- [ ] Añadir traducciones a `Localizable.xcstrings`
- [ ] Reemplazar strings hardcodeados con `L10n.constant`
- [ ] Probar en español (simulador/scheme)
- [ ] Probar en inglés (simulador/scheme)
- [ ] Verificar que todo se ve bien en ambos idiomas

---

**¡Tu app ahora habla dos idiomas!** 🇪🇸🇬🇧✨
