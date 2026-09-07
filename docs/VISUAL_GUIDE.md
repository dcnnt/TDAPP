# 🎨 Guía Visual de Configuración

## 📱 Pantalla de Configuración (Español)

```
┌─────────────────────────────────┐
│  ← Configuración          Listo │
├─────────────────────────────────┤
│                                 │
│ ℹ️  INFORMACIÓN                  │
│ Personaliza qué secciones están │
│ abiertas por defecto cuando     │
│ abres la app. Tus preferencias  │
│ se guardan automáticamente.     │
│                                 │
│ 👁️  SECCIONES VISIBLES          │
│ Oculta las secciones que no uses│
│                                 │
│ ☑️  Sueño y medicación          │
│ ☑️  Cómo te sientes             │
│ ☑️  Actividades del día         │
│ ☑️  Gimnasio                    │
│ ☑️  Hábitos                     │
│ ☑️  Notas del día               │
│                                 │
│ 📂 SECCIONES EXPANDIDAS         │
│ Elige qué secciones quieres ver │
│ abiertas por defecto            │
│                                 │
│ ☑️  Sueño y medicación          │
│ ☑️  Cómo te sientes             │
│ ☐  Actividades del día         │
│ ☐  Gimnasio                    │
│ ☐  Hábitos                     │
│ ☐  Notas del día               │
│                                 │
│ 💊 MEDICACIÓN                   │
│ Incluir campos de medicación    │
│                                 │
│ ☑️  Mostrar medicación          │
│                                 │
│ ✓  HÁBITOS PREDETERMINADOS      │
│ Activa o desactiva los hábitos  │
│ que quieres seguir              │
│                                 │
│ ☑️  Hilo dental                 │
│ ☑️  Alcohol                     │
│ ☑️  Meditación                  │
│ ☑️  Lectura                     │
│ ☑️  Pantallas antes de dormir   │
│                                 │
│ 🎨 HÁBITOS PERSONALIZADOS       │
│ Próximamente: añade tus propios │
│ hábitos para hacer seguimiento. │
│                                 │
│ ➕ Añadir hábito personalizado  │
│                                 │
│ 🔄 RESTABLECER                  │
│                                 │
│ 🔴 Restablecer preferencias     │
│                                 │
│ Versión 1.0.0 • Hecho con ❤️   │
│ para tu bienestar              │
└─────────────────────────────────┘
```

## 📱 Settings Screen (English)

```
┌─────────────────────────────────┐
│  ← Settings               Done  │
├─────────────────────────────────┤
│                                 │
│ ℹ️  INFORMATION                 │
│ Customize which sections are    │
│ open by default when you open   │
│ the app. Your preferences are   │
│ saved automatically.            │
│                                 │
│ 👁️  VISIBLE SECTIONS            │
│ Hide sections you don't use     │
│                                 │
│ ☑️  Sleep & Medication          │
│ ☑️  How You Feel                │
│ ☑️  Daily Activities            │
│ ☑️  Gym                         │
│ ☑️  Habits                      │
│ ☑️  Daily Notes                 │
│                                 │
│ 📂 EXPANDED SECTIONS            │
│ Choose which sections to open   │
│ by default                      │
│                                 │
│ ☑️  Sleep & Medication          │
│ ☑️  How You Feel                │
│ ☐  Daily Activities            │
│ ☐  Gym                         │
│ ☐  Habits                      │
│ ☐  Daily Notes                 │
│                                 │
│ 💊 MEDICATION                   │
│ Include medication fields       │
│                                 │
│ ☑️  Show medication             │
│                                 │
│ ✓  DEFAULT HABITS               │
│ Enable or disable habits you    │
│ want to track                   │
│                                 │
│ ☑️  Dental floss                │
│ ☑️  Alcohol                     │
│ ☑️  Meditation                  │
│ ☑️  Reading                     │
│ ☑️  Screens before bed          │
│                                 │
│ 🎨 CUSTOM HABITS                │
│ Coming soon: add your own       │
│ habits to track.                │
│                                 │
│ ➕ Add custom habit             │
│                                 │
│ 🔄 RESET                        │
│                                 │
│ 🔴 Reset Preferences            │
│                                 │
│ Version 1.0.0 • Made with ❤️   │
│ for your wellbeing             │
└─────────────────────────────────┘
```

## 📊 Ejemplos de personalización

### Caso 1: Solo seguimiento de ánimo y sueño

**Configuración:**
- Secciones visibles: Solo "Sueño y medicación" + "Cómo te sientes"
- Mostrar medicación: ❌
- Hábitos: (no importa, sección oculta)

**Formulario resultante:**
```
┌─────────────────────────────────┐
│  ← Bitácora         ⚙️  ↗️      │
├─────────────────────────────────┤
│  Viernes, 4 de septiembre       │
│  ●●●●●●●●●●●●●●●●●●●●●         │
│                                 │
│ ┌──────────────────────────┐   │
│ │ 🌙 Sueño                 2│   │
│ │   [EXPANDIDO]            │   │
│ │   Hora de despertar: 7:30│   │
│ │   Calidad del sueño: 7   │   │
│ └──────────────────────────┘   │
│                                 │
│ ┌──────────────────────────┐   │
│ │ ❤️  Cómo te sientes     3/3│  │
│ │   [EXPANDIDO]            │   │
│ │   Ánimo: 8               │   │
│ │   Energía: 7             │   │
│ │   Foco: 6                │   │
│ └──────────────────────────┘   │
└─────────────────────────────────┘
```

### Caso 2: Usuario deportista sin medicación

**Configuración:**
- Secciones visibles: Todas excepto "Actividades del día"
- Mostrar medicación: ❌
- Hábitos: Todos ✅

**Formulario resultante:**
```
┌─────────────────────────────────┐
│  ← Journal          ⚙️  ↗️      │
├─────────────────────────────────┤
│  Friday, September 4            │
│  ●●●●●●●●●●●●●●●●●●●●●         │
│                                 │
│ 🌙 Sleep                     2  │
│ ❤️  How You Feel            3/3 │
│ 🏋️  Gym                      ✓  │
│ ✓  Habits                    3  │
│ 📝 Daily Notes               ✓  │
│                                 │
│ [Sin "Activities" ni campos de  │
│  medicación]                    │
└─────────────────────────────────┘
```

### Caso 3: Solo hábitos específicos

**Configuración:**
- Secciones visibles: Solo "Hábitos"
- Hábitos activados: Solo "Meditación" y "Lectura"

**Sección de hábitos:**
```
┌──────────────────────────────┐
│ ✓ Hábitos                  2 │
│   [EXPANDIDO]                │
│                              │
│ ☑️  Meditación               │
│     📝 Minutos: 20           │
│ ─────────────────────────    │
│ ☑️  Lectura                  │
│     📝 Minutos: 30           │
│                              │
│ (Hilo dental, Alcohol y      │
│  Pantallas: OCULTOS)         │
└──────────────────────────────┘
```

## 🎯 Flujos de uso

### Primer uso de la app

```
1. Usuario abre la app
   ↓
2. Ve todas las secciones (configuración por defecto)
   ↓
3. Se da cuenta de que no usa algunas cosas
   ↓
4. Toca ⚙️ (Configuración)
   ↓
5. Desactiva secciones y hábitos que no usa
   ↓
6. Vuelve a la bitácora
   ↓
7. 🎉 Interfaz limpia y personalizada
```

### Cambiar de idioma

```
1. iPhone en español → App en español ✅
   ↓
2. Settings > Language & Region > English
   ↓
3. Abrir app de nuevo
   ↓
4. 🎉 Toda la app en inglés automáticamente
```

### Dejar de tomar medicación

```
1. Usuario tomaba medicación antes
   ↓
2. Ya no la necesita
   ↓
3. Configuración > Medicación > ❌ Desactivar
   ↓
4. Campos de medicación desaparecen
   ↓
5. Sección ahora solo tiene sueño
   ↓
6. Datos históricos de medicación se conservan
```

## 💡 Tips de UX

### Badges inteligentes
```
Antes (con medicación activada):
┌──────────────────────────┐
│ 🌙 Sueño y medicación  4 │  ← 4 campos
└──────────────────────────┘

Después (sin medicación):
┌──────────────────────────┐
│ 🌙 Sueño y medicación  2 │  ← Solo 2 campos
└──────────────────────────┘
```

### Dividers dinámicos
```
5 hábitos activos:
┌──────────────────┐
│ Hilo dental      │
│ ───────────      │  ← Divider
│ Alcohol          │
│ ───────────      │  ← Divider
│ Meditación       │
│ ───────────      │  ← Divider
│ Lectura          │
│ ───────────      │  ← Divider
│ Pantallas        │
└──────────────────┘

Solo 2 hábitos activos:
┌──────────────────┐
│ Meditación       │
│ ───────────      │  ← Solo 1 divider
│ Lectura          │
└──────────────────┘
```

### Mensaje cuando no hay hábitos
```
Si desactivas TODOS los hábitos:

┌──────────────────────────────┐
│ ✓ Hábitos                    │
│   [EXPANDIDO]                │
│                              │
│   Ve a Configuración para    │
│   activar hábitos            │
│                              │
└──────────────────────────────┘
```

## 🌐 Detección automática de idioma

La app usa el idioma del sistema automáticamente:

```swift
// NO hace falta configurar nada en código
// SwiftUI lo maneja automáticamente

// Ejemplo de uso:
Text(L10n.settings)  
// iPhone en ES → "Configuración"
// iPhone en EN → "Settings"
```

## 📦 Archivos necesarios

Para que funcione la localización:

1. **Localizable.xcstrings** ← Traducciones
2. **Localization.swift** ← Constantes L10n
3. **Xcode Project Settings:**
   - Info > Localizations > Spanish ✅
   - Info > Localizations > English ✅

## ✅ Checklist de implementación

- [x] Crear Localizable.xcstrings
- [x] Crear Localization.swift
- [x] Actualizar todas las vistas con L10n
- [x] Añadir configuración de secciones visibles
- [x] Añadir configuración de hábitos
- [x] Añadir toggle de medicación
- [x] Actualizar badges para ser contextuales
- [x] Añadir dividers dinámicos
- [x] Mensaje cuando no hay hábitos
- [x] Actualizar SettingsView
- [x] Actualizar DayView
- [x] Actualizar MainTabView
- [x] Probar en español
- [x] Probar en inglés
- [x] Documentación completa

## 🎉 ¡Listo para usar!

La app ahora es:
- ✅ **Multiidioma** (ES/EN)
- ✅ **Personalizable** al 100%
- ✅ **Limpia** (sin campos innecesarios)
- ✅ **Inteligente** (badges contextuales)
- ✅ **Flexible** (para cualquier estilo de vida)
