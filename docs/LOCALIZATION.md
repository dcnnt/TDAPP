# Configuración de Localización

## Pasos para configurar la app en español e inglés

### 1. En Xcode, abre tu proyecto
- Haz clic en el nombre del proyecto en el navegador de archivos (panel izquierdo)
- Selecciona el TARGET de tu app (no el proyecto)

### 2. Añade idiomas
- En la pestaña "Info", busca la sección "Localizations"
- Si solo ves "English - Development Language", haz clic en el botón "+"
- Añade "Spanish (es)"

### 3. Añade el archivo de strings
- Arrastra el archivo `Localizable.xcstrings` a tu proyecto en Xcode
- Asegúrate de que está marcado en "Target Membership" para tu app

### 4. Verifica los archivos
Asegúrate de que estos archivos estén en tu proyecto:
- `Localizable.xcstrings` - Archivo de traducciones
- `Localization.swift` - Constantes de localización (L10n)

### 5. Prueba la app
- Para probar en inglés: Settings > General > Language & Region > iPhone Language > English
- Para probar en español: Settings > General > Language & Region > iPhone Language > Español

### 6. En el simulador (más rápido)
- Edit Scheme > Run > Options > App Language > Spanish/English
- Run de nuevo

## Archivos incluidos

### Localizable.xcstrings
Contiene todas las traducciones en formato xcstrings (nuevo formato de Xcode).
Este archivo gestiona automáticamente las traducciones en español e inglés.

### Localization.swift
Define constantes L10n que se usan en todo el código:
```swift
L10n.tabJournal  // "Bitácora" o "Journal"
L10n.settings    // "Configuración" o "Settings"
```

## Nuevas funcionalidades implementadas

### 1. **Hábitos configurables**
En Ajustes puedes activar/desactivar cada hábito:
- Hilo dental
- Alcohol
- Meditación
- Lectura
- Pantallas antes de dormir

Los hábitos desactivados no se muestran en la sección de Hábitos.

### 2. **Secciones visibles**
En Ajustes puedes ocultar secciones completas que no uses:
- Sueño y medicación
- Cómo te sientes
- Actividades del día
- Gimnasio
- Hábitos
- Notas del día

### 3. **Medicación opcional**
En Ajustes puedes desactivar "Mostrar medicación" para:
- Ocultar el campo "Hora de la medicación"
- Ocultar el campo "Notas sobre la medicación"
- Mantener solo sueño en esa sección

### 4. **Secciones expandidas por defecto**
Ya podías configurar esto antes, pero ahora funciona junto con las secciones visibles.

### 5. **Badges inteligentes**
Los badges (números en las secciones) ahora:
- Solo cuentan hábitos que están activados
- Solo cuentan campos de medicación si está activada

### 6. **Localización completa**
Toda la interfaz está en español e inglés:
- Tabs principales
- Nombres de secciones
- Botones y acciones
- Mensajes de estado
- Gráficas y estadísticas

## Uso recomendado

### Si no tomas medicación:
1. Ve a Configuración
2. Desactiva "Mostrar medicación"
3. La sección de "Sueño y medicación" solo mostrará sueño

### Si no sigues algunos hábitos:
1. Ve a Configuración > Hábitos predeterminados
2. Desactiva los que no uses (por ejemplo, si no bebes alcohol)
3. Solo aparecerán los hábitos que marcaste

### Si hay secciones que nunca usas:
1. Ve a Configuración > Secciones visibles
2. Desactiva las que no necesites (por ejemplo, Gimnasio si no vas)
3. Esas secciones desaparecerán completamente del formulario

## Ejemplo de uso personalizado

**Persona que no va al gimnasio, no bebe alcohol, y no toma medicación:**

En Configuración:
- Secciones visibles: Desactivar "Gimnasio"
- Mostrar medicación: Desactivar
- Hábitos predeterminados: Desactivar "Alcohol"

Resultado: App mucho más limpia y enfocada en lo que realmente usas.
