# Bitácora — montar el proyecto en Xcode

Cinco archivos Swift y un proyecto vacío. En 15 minutos la tienes corriendo en tu iPhone.

## Lo que necesitas

- Un Mac con **Xcode 15 o superior** (gratis en la Mac App Store)
- Un iPhone con **iOS 17 o superior**
- Un cable para conectarlo la primera vez
- Un Apple ID (el tuyo de siempre vale)

## 1. Crear el proyecto

1. Abre Xcode → **File › New › Project**
2. Elige **iOS › App** y dale a Next
3. Rellena así:
   - Product Name: `Bitacora`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None** (el código ya configura SwiftData)
   - Deja sin marcar "Include Tests"
4. Guárdalo donde quieras

## 2. Meter los archivos

Xcode te habrá creado un `BitacoraApp.swift` y un `ContentView.swift`.

1. Borra los dos (clic derecho → Delete → **Move to Trash**)
2. Arrastra estos cuatro archivos a la carpeta amarilla `Bitacora` del panel izquierdo:
   - `BitacoraApp.swift`
   - `Models.swift`
   - `Components.swift`
   - `DayView.swift`
   - `Export.swift`
3. En el diálogo que sale, marca **Copy items if needed** y que el target `Bitacora` esté seleccionado

## 3. Probarla en el simulador

Arriba a la izquierda elige un iPhone en el desplegable y dale al botón ▶︎ (o `Cmd + R`).
Debería arrancar en el día de hoy, vacía y lista para escribir.

## 4. Instalarla en tu iPhone de verdad

1. Conecta el iPhone por cable y desbloquéalo
2. En Xcode: **Xcode › Settings › Accounts › +** y añade tu Apple ID
3. Selecciona el proyecto (icono azul arriba del todo) → pestaña **Signing & Capabilities**
   - Marca **Automatically manage signing**
   - En Team, elige tu Apple ID (aparecerá como "… (Personal Team)")
   - Si se queja del Bundle Identifier, cámbialo por algo único: `com.tunombre.bitacora`
4. Arriba elige tu iPhone en vez del simulador y dale a ▶︎
5. La primera vez el iPhone la bloqueará. Ve a **Ajustes › General › VPN y gestión de dispositivos**, toca tu Apple ID y dale a **Confiar**

Ya la tienes en la pantalla de inicio.

### Sobre los 7 días

Con un Apple ID normal (gratis), la app **caduca a los 7 días** y hay que volver a darle a ▶︎ desde Xcode.
Los datos **no se pierden** al renovarla, solo deja de abrirse hasta que la reinstalas.

Si eso te cansa, la cuenta de Apple Developer (99 €/año) sube la caducidad a un año.

## Cómo funciona por dentro

- **Los datos viven solo en tu iPhone.** No hay servidor ni cuenta. Nadie más los ve.
- Un día **no se guarda hasta que escribes algo** en él. Si navegas por el calendario sin tocar nada, no se llena de días vacíos.
- Las puntuaciones (sueño, ánimo, energía, foco) pueden quedarse **sin valor**. Toca el mismo número otra vez para borrarlo. Eso importa para el análisis: un día sin puntuar no es lo mismo que un día con un 0.
- Los puntos de la tira superior se colorean según el ánimo, para ver la racha de un vistazo.
- El **CSV** lleva una fila por día, con las actividades juntas en una celda. El **JSON** guarda cada actividad por separado y omite los campos vacíos, que es lo que quieres para pegárselo a una IA.

## Copia de seguridad

Como todo vive en el teléfono, si lo pierdes pierdes los datos (salvo que tengas copia de iCloud del dispositivo entero).
Exporta el JSON de vez en cuando y guárdalo en tu Drive. Con eso estás cubierto.

## Siguientes pasos, cuando la uses un tiempo

Por orden de utilidad real:

1. **Recordatorio diario** — una notificación local a las 22h para apuntar el día. Es lo que más va a hacer que no la abandones.
2. **Vista de resumen** — un gráfico de ánimo/sueño/energía por semanas, y correlaciones (¿duermes peor los días que bebes? ¿el foco baja cuando duermes menos de 6?).
3. **Importar tu hoja actual** — pasar el histórico del Excel a la app para no empezar de cero.
4. **Sincronización con iCloud** — para que los datos sobrevivan a un cambio de teléfono. SwiftData lo soporta casi gratis.

Dime cuál quieres y lo montamos.
