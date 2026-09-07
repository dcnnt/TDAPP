# 🎯 Bitácora — Tu app de seguimiento de salud mental

Una app completa para hacer seguimiento diario de tu medicación, ánimo, hábitos y más. Diseñada para **reducir la fricción** y facilitar el análisis con IA.

## 🆕 NUEVA VERSIÓN 1.1.0

### ✨ Novedades principales:

#### 🌍 **Multiidioma (Español e Inglés)**
- Detección automática del idioma del dispositivo
- Toda la interfaz completamente traducida
- Cambia de idioma y la app se adapta automáticamente

#### 🎨 **Personalización total**
- **Oculta secciones completas** que no uses (Gimnasio, Actividades, etc.)
- **Desactiva hábitos individuales** (Alcohol, Pantallas, etc.)
- **Quita la medicación** si no la necesitas
- **Badges inteligentes** que reflejan tu configuración

#### ⚙️ **Nueva configuración completa**
- Secciones visibles: Oculta lo que no uses
- Secciones expandidas: Controla qué está abierto por defecto
- Medicación: Activa/desactiva campos de medicación
- Hábitos predeterminados: Activa solo los que sigues

### 📚 Documentación nueva:
- **[SUMMARY.md](SUMMARY.md)** - Resumen ejecutivo de las mejoras
- **[IMPLEMENTATION.md](IMPLEMENTATION.md)** - Guía paso a paso para implementar
- **[VISUAL_GUIDE.md](VISUAL_GUIDE.md)** - Guía visual con ejemplos
- **[LOCALIZATION.md](LOCALIZATION.md)** - Configurar idiomas en Xcode
- **[CHANGELOG.md](CHANGELOG.md)** - Lista completa de cambios

---

## ✨ Características principales

### 📱 Tres pestañas principales

#### 1️⃣ **Bitácora** (pestaña principal)
- **Secciones colapsables** que reducen la sobrecarga visual
- **Secciones personalizables**: Oculta las que no uses
- Solo ves lo que necesitas en cada momento
- Las secciones **recuerdan tu preferencia** (si las dejas abiertas, permanecen así)
- Badges que indican cuántos campos has rellenado

**Secciones (todas opcionales):**
- 🌙 **Sueño y medicación**: hora de despertar, calidad del sueño, medicación (opcional) y notas
- ❤️ **Cómo te sientes**: ánimo, energía y foco (escala 1-5)
- 📋 **Actividades del día**: lista con timestamps de lo que hiciste
- 🏋️ **Gimnasio**: checkbox y tipo de entrenamiento
- ✅ **Hábitos** (configurables): hilo dental, alcohol, meditación, lectura, pantallas
- 📝 **Notas del día**: campo libre para escribir lo que quieras

#### 2️⃣ **Resumen semanal**
- Vista de **tarjetas por semana**
- Promedio de ánimo semanal
- **Todas las notas** agrupadas por semana
- Mini calendario visual de cada semana

#### 3️⃣ **Gráficas y estadísticas**
- **Gráficas de línea** para ánimo, sueño, energía y foco
- Cambia el período: 7, 14 o 30 días
- **Estadísticas**: promedio, máximo, mínimo
- **Rachas de hábitos** con contador de días consecutivos
- Total de días que has cumplido cada hábito

### ⚙️ Configuración (NUEVA)
- **Secciones visibles**: Oculta secciones completas que no uses
- **Secciones expandidas**: Elige cuáles quieres abiertas por defecto
- **Medicación**: Activa/desactiva campos de medicación
- **Hábitos predeterminados**: Activa solo los hábitos que sigues
- **Hábitos personalizados** (próximamente): añade tus propios hábitos con icono
- Botón de restablecer preferencias

### 📤 Exportación
- **CSV**: una fila por día, ideal para Excel
- **JSON**: estructura completa, perfecto para análisis con IA (ChatGPT, Claude, etc.)

### 🎨 Diseño
- Interfaz minimalista con paleta de colores suaves
- Animaciones fluidas
- Vibración táctil al puntuar
- Teclado se oculta automáticamente
- **Multiidioma**: 🇪🇸 Español / 🇬🇧 English

---

## 📋 Cómo usar la app

### Día a día
1. Abre la app → verás el día de hoy
2. Toca las secciones que quieras rellenar (se expanden)
3. Rellena lo que necesites → se guarda automáticamente
4. Los badges te muestran qué has completado

### Personalizar (NUEVO)
1. Toca el icono ⚙️ en la esquina superior derecha
2. **Secciones visibles**: Desactiva las que no uses (ej: Gimnasio si no vas)
3. **Medicación**: Desactiva si no tomas medicación
4. **Hábitos**: Desactiva los que no sigas (ej: Alcohol si no bebes)
5. Vuelve a la bitácora → ¡Interfaz limpia y personalizada!

### Ver tu progreso
1. Pestaña **Resumen**: ve tus semanas con notas agrupadas
2. Pestaña **Gráficas**: analiza tendencias y rachas

### Exportar para análisis
1. Botón de exportar (flecha arriba) en la Bitácora
2. Elige CSV o JSON
3. Comparte con tu app de IA favorita

---

## 🚀 Instalación (15 minutos)

### Requisitos
- Mac con **Xcode 15+**
- iPhone con **iOS 17+**
- Apple ID

### Pasos rápidos

1. Abre Xcode → **File › New › Project**
2. Elige **iOS › App**:
   - Product Name: `Bitacora`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None**

3. **Arrastra estos archivos al proyecto:**
   - `BitacoraApp.swift`
   - `MainTabView.swift`
   - `DayView.swift`
   - `SettingsView.swift`
   - `Models.swift`
   - `Components.swift`
   - `Export.swift`
   - `Localization.swift` **(NUEVO)**
   - `Localizable.xcstrings` **(NUEVO)**
   - `ContentView.swift` (opcional)

4. **Configurar idiomas:**
   - Proyecto > Info > Localizations
   - Añadir "Spanish (es)" si no está

5. **Para instalar en tu iPhone:**
   - Conecta el iPhone por cable
   - Xcode › Settings › Accounts › añade tu Apple ID
   - Proyecto › Signing & Capabilities › marca **Automatically manage signing**
   - Elige tu iPhone arriba y dale a ▶︎
   - Primera vez: Ajustes › General › VPN y gestión › Confiar

**⚠️ Con Apple ID gratis:** la app caduca cada 7 días (hay que reinstalar, pero **los datos NO se pierden**).

### Ver en inglés (para probar)

1. Edit Scheme > Run > Options > App Language > English
2. Cmd + R

---

## 🎯 Ejemplos de personalización

### Usuario minimalista
**Solo sigue ánimo y sueño, no toma medicación:**

Configuración:
- Secciones visibles: Solo "Sueño y medicación" + "Cómo te sientes"
- Mostrar medicación: ❌
- Resultado: App con solo 2 secciones ✨

### Deportista
**Va al gimnasio, no bebe alcohol, no toma medicación:**

Configuración:
- Secciones visibles: Todas menos "Actividades"
- Mostrar medicación: ❌
- Hábitos: Desactivar "Alcohol"
- Resultado: App deportiva sin campos innecesarios ✨

### Usuario completo
**Usa todas las funciones:**

Configuración:
- Todo activado (comportamiento por defecto)
- Resultado: App completa como siempre ✨

---

## 🧠 Arquitectura

### Archivos principales

#### `BitacoraApp.swift`
Punto de entrada de la app. Configura SwiftData y lanza `MainTabView`.

#### `MainTabView.swift`
TabView con las 3 pestañas: Bitácora, Resumen, Gráficas. Ahora con localización completa.

#### `DayView.swift`
Vista principal del formulario diario con secciones colapsables.
- Usa `@AppStorage` para recordar qué secciones están abiertas
- **NUEVO:** Secciones visibles configurables
- **NUEVO:** Hábitos configurables individualmente
- **NUEVO:** Medicación opcional
- **NUEVO:** Localización ES/EN
- Badges dinámicos según campos rellenados

#### `SettingsView.swift`
Configuración de la app:
- **NUEVO:** Secciones visibles (ocultar completas)
- Toggles para secciones expandidas
- **NUEVO:** Toggle de medicación
- **NUEVO:** Hábitos predeterminados individuales
- Hábitos personalizados (próximamente funcional)
- **NUEVO:** Localización ES/EN
- Restablecer preferencias

#### `Models.swift`
Modelos de datos con SwiftData:
- `DayEntry`: un día completo (fecha, puntuaciones, notas, etc.)
- `ActivityItem`: una actividad con timestamp
- Sin cambios en esta versión (backward compatible)

#### `Components.swift`
Componentes reutilizables:
- `CollapsibleSection`: sección expandible con badge
- `RatingPicker`: selector 1-5 con círculos
- `ToggleRow`: toggle con campo opcional que aparece debajo
- `HistoryStrip`: tira de últimos días con puntos de colores

#### `Export.swift`
Lógica de exportación a CSV y JSON.

#### `Localization.swift` (NUEVO)
Constantes de localización (L10n) para usar en todo el código.

#### `Localizable.xcstrings` (NUEVO)
Catálogo de traducciones español/inglés en formato moderno de Xcode.

---

## 🎯 Próximas mejoras

### Prioritarias
1. ✅ **Secciones colapsables** — ¡Hecho!
2. ✅ **TabView con resumen y gráficas** — ¡Hecho!
3. ✅ **Configuración de secciones** — ¡Hecho!
4. ✅ **Localización ES/EN** — ¡Hecho!
5. ✅ **Hábitos configurables** — ¡Hecho!
6. ✅ **Medicación opcional** — ¡Hecho!
7. ⏳ **Hábitos personalizables funcionales** (próximamente)
8. ⏳ **Recordatorio diario** (notificación a las 22h)

### Avanzadas
- Renombrar dinámicamente "Sueño y medicación" a solo "Sueño" cuando medicación está desactivada
- Vista de correlaciones (¿duermes peor cuando bebes?)
- Importador desde CSV/Excel
- Sincronización con iCloud
- Widget para iOS
- Exportación automática a iCloud Drive

---

## 🔒 Privacidad

- **Todo es local**: tus datos solo viven en tu iPhone
- **No hay servidor**: nadie más puede verlos
- **No hay cuenta**: no necesitas registrarte
- **No hay analytics**: cero seguimiento

### Copia de seguridad
Como todo vive en el teléfono, exporta el JSON de vez en cuando y guárdalo en tu Drive.

---

## 💡 Tips de uso

### Para análisis con IA
1. Exporta el JSON
2. Pégalo en ChatGPT/Claude con un prompt como:
   > "Analiza mi bitácora de salud mental. Busca patrones entre mi ánimo, sueño y hábitos. ¿Qué me afecta positiva o negativamente?"

### Reducir fricción
- Deja abiertas las secciones que uses todos los días (sueño, ánimo)
- Cierra las que uses menos (actividades, gimnasio)
- **NUEVO:** Oculta las secciones que nunca uses
- **NUEVO:** Desactiva hábitos que no sigas
- La app recordará tu preferencia

### Hacer seguimiento constante
- Usa el calendario superior para navegar días
- El botón "Hoy" te devuelve al presente
- La tira de puntos te muestra tu racha de ánimo de un vistazo

### Cambiar de idioma
- La app detecta automáticamente el idioma del iPhone
- Settings > Language & Region > Español/English
- La app cambia automáticamente al abrir

---

## 🐛 Problemas conocidos

- Los hábitos personalizados todavía no se integran en el formulario (próximamente)
- La exportación funciona igual que antes

---

## 📝 Licencia

Código libre para uso personal. Si quieres modificarlo o distribuirlo, adelante.

---

## 📚 Documentación adicional

- **[SUMMARY.md](SUMMARY.md)** - Resumen de las nuevas funcionalidades
- **[IMPLEMENTATION.md](IMPLEMENTATION.md)** - Guía completa paso a paso
- **[VISUAL_GUIDE.md](VISUAL_GUIDE.md)** - Ejemplos visuales de uso
- **[LOCALIZATION.md](LOCALIZATION.md)** - Configurar idiomas en Xcode
- **[CHANGELOG.md](CHANGELOG.md)** - Historial completo de cambios

---

**Versión:** 1.1.0  
**Última actualización:** Septiembre 2026  
**¿Dudas o sugerencias?** Abre un issue o mejora el código directamente. ¡Que te sirva! 💚

---

## 🎉 Lo nuevo en 1.1.0

- 🌍 Multiidioma (Español/Inglés)
- 👁️ Secciones visibles configurables
- 💊 Medicación opcional
- ✅ Hábitos configurables individualmente
- 📊 Badges inteligentes contextuales
- 🎨 Interfaz adaptable al 100%
- 📚 Documentación completa
- 🔄 Restablecer preferencias mejorado

**Actualiza tu app y disfruta de la nueva experiencia personalizada!** ✨

### 📱 Tres pestañas principales

#### 1️⃣ **Bitácora** (pestaña principal)
- **Secciones colapsables** que reducen la sobrecarga visual
- Solo ves lo que necesitas en cada momento
- Las secciones **recuerdan tu preferencia** (si las dejas abiertas, permanecen así)
- Badges que indican cuántos campos has rellenado

**Secciones:**
- 🌙 **Sueño y medicación**: hora de despertar, calidad del sueño, medicación y notas
- ❤️ **Cómo te sientes**: ánimo, energía y foco (escala 1-5)
- 📋 **Actividades del día**: lista con timestamps de lo que hiciste
- 🏋️ **Gimnasio**: checkbox y tipo de entrenamiento
- ✅ **Hábitos**: hilo dental, alcohol, meditación, lectura, pantallas
- 📝 **Notas del día**: campo libre para escribir lo que quieras

#### 2️⃣ **Resumen semanal**
- Vista de **tarjetas por semana**
- Promedio de ánimo semanal
- **Todas las notas** agrupadas por semana
- Mini calendario visual de cada semana

#### 3️⃣ **Gráficas y estadísticas**
- **Gráficas de línea** para ánimo, sueño, energía y foco
- Cambia el período: 7, 14 o 30 días
- **Estadísticas**: promedio, máximo, mínimo
- **Rachas de hábitos** con contador de días consecutivos
- Total de días que has cumplido cada hábito

### ⚙️ Configuración
- **Personaliza secciones**: elige cuáles quieres abiertas por defecto
- **Hábitos personalizados** (próximamente): añade tus propios hábitos con icono
- Botón de restablecer preferencias

### 📤 Exportación
- **CSV**: una fila por día, ideal para Excel
- **JSON**: estructura completa, perfecto para análisis con IA (ChatGPT, Claude, etc.)

### 🎨 Diseño
- Interfaz minimalista con paleta de colores suaves
- Animaciones fluidas
- Vibración táctil al puntuar
- Teclado se oculta automáticamente

---

## 📋 Cómo usar la app

### Día a día
1. Abre la app → verás el día de hoy
2. Toca las secciones que quieras rellenar (se expanden)
3. Rellena lo que necesites → se guarda automáticamente
4. Los badges te muestran qué has completado

### Ver tu progreso
1. Pestaña **Resumen**: ve tus semanas con notas agrupadas
2. Pestaña **Gráficas**: analiza tendencias y rachas

### Exportar para análisis
1. Botón de exportar (flecha arriba) en la Bitácora
2. Elige CSV o JSON
3. Comparte con tu app de IA favorita

---

## 🚀 Instalación (15 minutos)

### Requisitos
- Mac con **Xcode 15+**
- iPhone con **iOS 17+**
- Apple ID

### Pasos
1. Abre Xcode → **File › New › Project**
2. Elige **iOS › App**:
   - Product Name: `Bitacora`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None**
3. Arrastra estos archivos al proyecto:
   - `BitacoraApp.swift`
   - `MainTabView.swift`
   - `DayView.swift`
   - `SettingsView.swift`
   - `Models.swift`
   - `Components.swift`
   - `Export.swift`
   - `ContentView.swift` (opcional, es un wrapper)

4. **Para instalar en tu iPhone:**
   - Conecta el iPhone por cable
   - Xcode › Settings › Accounts › añade tu Apple ID
   - Proyecto › Signing & Capabilities › marca **Automatically manage signing**
   - Elige tu iPhone arriba y dale a ▶︎
   - Primera vez: Ajustes › General › VPN y gestión › Confiar

**⚠️ Con Apple ID gratis:** la app caduca cada 7 días (hay que reinstalar, pero **los datos NO se pierden**).

---

## 🧠 Arquitectura

### Archivos principales

#### `BitacoraApp.swift`
Punto de entrada de la app. Configura SwiftData y lanza `MainTabView`.

#### `MainTabView.swift`
TabView con las 3 pestañas: Bitácora, Resumen, Gráficas.

#### `DayView.swift`
Vista principal del formulario diario con secciones colapsables.
- Usa `@AppStorage` para recordar qué secciones están abiertas
- Badges dinámicos según campos rellenados
- Botón de configuración

#### `SettingsView.swift`
Configuración de la app:
- Toggles para secciones expandidas
- Hábitos personalizados (próximamente funcional)
- Restablecer preferencias

#### `Models.swift`
Modelos de datos con SwiftData:
- `DayEntry`: un día completo (fecha, puntuaciones, notas, etc.)
- `ActivityItem`: una actividad con timestamp

#### `Components.swift`
Componentes reutilizables:
- `CollapsibleSection`: sección expandible con badge
- `RatingPicker`: selector 1-5 con círculos
- `ToggleRow`: toggle con campo opcional que aparece debajo
- `HistoryStrip`: tira de últimos días con puntos de colores

#### `Export.swift`
Lógica de exportación a CSV y JSON.

---

## 📊 Estructura de datos

### DayEntry (un día)
```swift
date: Date           // Día (normalizado a 00:00)
wakeTime: Date?      // Hora de despertar
medTime: Date?       // Hora de medicación
medNotes: String     // Notas de medicación

sleep: Int?          // 1-5
mood: Int?           // 1-5
energy: Int?         // 1-5
focus: Int?          // 1-5

didGym: Bool
gymType: String

floss: Bool
alcohol: Bool
alcoholDetail: String
meditated: Bool
meditationMinutes: Int?
didRead: Bool
readingMinutes: Int?
screensBeforeBed: Bool
screenMinutes: Int?

notes: String        // Notas libres del día
activities: [ActivityItem]
```

### ActivityItem
```swift
time: String         // "14:30"
text: String         // "Comí con María"
order: Int           // Para ordenar
```

---

## 🎯 Próximas mejoras

### Prioritarias
1. ✅ **Secciones colapsables** — ¡Hecho!
2. ✅ **TabView con resumen y gráficas** — ¡Hecho!
3. ✅ **Configuración de secciones** — ¡Hecho!
4. ⏳ **Hábitos personalizables funcionales** (próximamente)
5. ⏳ **Recordatorio diario** (notificación a las 22h)

### Avanzadas
- Vista de correlaciones (¿duermes peor cuando bebes?)
- Importador desde CSV/Excel
- Sincronización con iCloud
- Widget para iOS
- Exportación automática a iCloud Drive

---

## 🔒 Privacidad

- **Todo es local**: tus datos solo viven en tu iPhone
- **No hay servidor**: nadie más puede verlos
- **No hay cuenta**: no necesitas registrarte
- **No hay analytics**: cero seguimiento

### Copia de seguridad
Como todo vive en el teléfono, exporta el JSON de vez en cuando y guárdalo en tu Drive.

---

## 💡 Tips de uso

### Para análisis con IA
1. Exporta el JSON
2. Pégalo en ChatGPT/Claude con un prompt como:
   > "Analiza mi bitácora de salud mental. Busca patrones entre mi ánimo, sueño y hábitos. ¿Qué me afecta positiva o negativamente?"

### Reducir fricción
- Deja abiertas las secciones que uses todos los días (sueño, ánimo)
- Cierra las que uses menos (actividades, gimnasio)
- La app recordará tu preferencia

### Hacer seguimiento constante
- Usa el calendario superior para navegar días
- El botón "Hoy" te devuelve al presente
- La tira de puntos te muestra tu racha de ánimo de un vistazo

---

## 🐛 Problemas conocidos

- Los hábitos personalizados todavía no se integran en el formulario (próximamente)
- La exportación no incluye hábitos personalizados todavía

---

## 📝 Licencia

Código libre para uso personal. Si quieres modificarlo o distribuirlo, adelante.

---

**¿Dudas o sugerencias?** Abre un issue o mejora el código directamente. ¡Que te sirva! 💚
