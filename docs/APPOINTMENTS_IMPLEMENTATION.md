# 📅 Sistema de Citas Recurrentes - Implementación Completa

## ✅ Resumen de cambios

Se ha implementado un sistema completo de citas recurrentes sin fecha fija, pensado para sesiones de psicólogo, revisiones médicas y cualquier cita que se repite pero cuya siguiente fecha no se sabe hasta que terminas la anterior.

---

## 📁 Archivos NUEVOS creados (5):

### 1. **Models.swift** (ACTUALIZADO)
- ✅ Añadido modelo `RecurringAppointment` con:
  - `id`, `title`, `nextDate`, `lastCompletedDate`, `notes`, `eventKitIdentifier`
  - Helpers: `isScheduled`, `isPastDue`

### 2. **AppointmentManager.swift** (NUEVO)
- ✅ Manager observable con doble estrategia:
  - EventKit (preferido): Crea eventos en Calendario con 2 alarmas
  - UNNotifications (fallback): Notificaciones locales si no hay permiso
- ✅ Métodos principales:
  - `requestCalendarAccess()` - Pide permiso Full Access o Write-Only
  - `requestNotificationAccess()` - Pide permiso de notificaciones
  - `createCalendarEvent()` - Crea evento con 2 alarmas (1 día antes + 1 hora antes)
  - `updateCalendarEvent()` - Actualiza evento existente
  - `deleteCalendarEvent()` - Borra evento del calendario
  - `scheduleLocalNotifications()` - Fallback con notificaciones locales
  - `schedulePostAppointmentNotification()` - Notificación 2h después para agendar siguiente
- ✅ Manejo de estados de permisos
- ✅ Errores localizados

### 3. **AppointmentsView.swift** (NUEVO)
- ✅ Vista principal con 2 secciones: "Próximas" y "Sin fecha"
- ✅ Lista de citas ordenadas por fecha
- ✅ Botón "Ya fue" en cada cita
- ✅ Sheet de "¿Cuándo es la próxima?" con DatePicker
- ✅ Botón "Aún no lo sé" para postponer sin presión
- ✅ Sheet explicativo de permisos (primera vez)
- ✅ Sheet para añadir nueva cita
- ✅ Swipe to delete con limpieza automática de eventos

### 4. **Localization.swift** (NUEVO)
- ✅ Todas las constantes L10n para citas
- ✅ Español e inglés completo
- ✅ Función con parámetro: `appointmentsNextQuestion(_ title: String)`

### 5. **Localizable.xcstrings** (ACTUALIZADO)
- ✅ +20 nuevas strings para citas
- ✅ Traducciones ES/EN completas

### 6. **INFO_PLIST_INSTRUCTIONS.md** (NUEVO)
- ✅ Guía para añadir permisos de EventKit al Info.plist
- ✅ Descripciones en español e inglés

---

## 🔧 Archivos MODIFICADOS (4):

### 1. **DayView.swift**
**Cambios:**
- ✅ Añadido `@State showingAppointments`
- ✅ Añadido `@AppStorage("showAppointmentsInMenu")`
- ✅ Toolbar actualizado: Botón de settings reemplazado por Menu con `ellipsis.circle`
- ✅ Menu dinámico con:
  - Configuración (siempre visible)
  - Citas (si `showAppointmentsInMenu` está activado)
- ✅ Añadido `.sheet(isPresented: $showingAppointments)`

### 2. **SettingsView.swift**
**Cambios:**
- ✅ Nueva sección "Opciones del menú"
- ✅ Toggle "Mostrar Citas en el menú"
- ✅ Footer explicativo
- ✅ Actualizado `resetDefaults()` para incluir "showAppointmentsInMenu"

### 3. **BitacoraApp.swift**
**Cambios:**
- ✅ Añadido `RecurringAppointment.self` al `.modelContainer()`

### 4. **Components.swift**
**Sin cambios** - Sigue funcionando igual

---

## 🎯 Flujo de usuario implementado

### Crear primera cita:

```
1. Usuario toca Menu (ellipsis.circle) > Citas
   ↓
2. Toca "+" para añadir
   ↓
3. Rellena título (ej: "Psicólogo")
   ↓
4. (Opcional) Activa "Programar ahora" y elige fecha
   ↓
5. Toca "Crear cita"
   ↓
6. Si tiene fecha → Sheet de permisos aparece
   ↓
7. Usuario elige:
   - "Dar acceso al Calendario" → EventKit
   - "Solo notificaciones locales" → UNNotifications
   ↓
8. Cita creada ✅
   - Si EventKit: Aparece en Calendario con 2 alarmas
   - Si UNNotifications: 2 notificaciones programadas
   - Además: Notificación 2h después para agendar siguiente
```

### Completar cita y agendar siguiente:

```
1. Usuario toca "Ya fue" en una cita
   ↓
2. Se guarda lastCompletedDate = hoy
   ↓
3. Sheet aparece: "¿Cuándo es la próxima cita de [Psicólogo]?"
   ↓
4. Usuario elige:
   A) Selecciona fecha → Crea/actualiza evento
   B) "Aún no lo sé" → nextDate queda nil
   ↓
5. Cita actualizada ✅
   - Si tiene fecha: Aparece en "Próximas"
   - Si no: Aparece en "Sin fecha"
```

### Notificación post-cita:

```
[2 horas después de la hora de la cita]
↓
📱 Notificación: "¿Ya terminó tu cita?"
   "¿Cuándo es la próxima cita de Psicólogo? Toca para agendar 📅"
↓
Usuario toca notificación
↓
App se abre (puede ir directo al sheet en una implementación futura)
```

---

## 🔔 Sistema de notificaciones

### Con permiso de EventKit (PREFERIDO):

**Alarmas automáticas del sistema:**
- ✅ 1 día antes a la misma hora
- ✅ 1 hora antes
- ✅ Manejadas por iOS (más fiables)
- ✅ Aparecen en la app Calendario
- ✅ Respetan "No Molestar" del usuario

**Plus:**
- ✅ Notificación adicional 2h después (UNNotifications)
- ✅ Para recordar agendar la siguiente

### Sin permiso de EventKit (FALLBACK):

**Notificaciones locales (UNUserNotificationCenter):**
- ✅ 1 día antes
- ✅ 1 hora antes
- ✅ 2 horas después
- ⚠️ NO aparece en Calendario
- ⚠️ Puede ser limpiada por el sistema si hay muchas

---

## ⚙️ Configuración implementada

### Nueva sección en Settings:

```
┌──────────────────────────────────┐
│ OPCIONES DEL MENÚ                │
│ Elige qué opciones aparecen en   │
│ el menú principal                │
│                                  │
│ ☑️  Mostrar Citas en el menú     │
│                                  │
└──────────────────────────────────┘
```

**Comportamiento:**
- ✅ Si está activado: "Citas" aparece en el menú
- ✅ Si está desactivado: "Citas" desaparece del menú
- ✅ Los datos de citas se conservan (no se borran)
- ✅ "Configuración" NUNCA se puede ocultar

**Preparado para futuras opciones:**
El menú se construye dinámicamente, fácil añadir:
- "Exportar"
- "Kanban"
- "Estadísticas avanzadas"
- etc.

---

## 📱 Testing en iPhone

### Checklist de pruebas:

#### Primera ejecución:
- [ ] Crear cita con fecha
- [ ] Sheet de permisos aparece
- [ ] Texto explicativo claro y sin presión
- [ ] Botones "Dar acceso" y "Solo notificaciones" funcionan

#### Con permiso de EventKit:
- [ ] Cita aparece en app Calendario del iPhone
- [ ] Evento tiene título correcto
- [ ] Evento tiene 2 alarmas (revisar en editar evento)
- [ ] Alarmas son: -1 día y -1 hora
- [ ] Notas de la cita aparecen en el evento

#### Sin permiso (UNNotifications):
- [ ] Notificaciones programadas correctamente
- [ ] Aparecen en Ajustes > Notificaciones > Bitácora

#### Completar cita:
- [ ] Botón "Ya fue" funciona
- [ ] Sheet de próxima fecha aparece inmediatamente
- [ ] DatePicker muestra hora actual
- [ ] "Programar" actualiza la cita
- [ ] "Aún no lo sé" mueve a "Sin fecha"

#### Actualizar cita:
- [ ] Cambiar fecha actualiza evento en Calendario
- [ ] Borrar cita borra evento en Calendario
- [ ] Swipe to delete funciona

#### Menú dinámico:
- [ ] Icono ellipsis.circle en toolbar
- [ ] Menu despliega con "Configuración" y "Citas"
- [ ] Desactivar "Citas" en Settings lo oculta del menú
- [ ] Reactivar lo muestra de nuevo

#### Notificación post-cita:
- [ ] Crear cita para dentro de 10 minutos (para testing rápido)
- [ ] Esperar 2 horas reales (o cambiar a 2 minutos en código para testing)
- [ ] Verificar que llega la notificación "¿Ya terminó tu cita?"

---

## 🚨 Problemas conocidos y soluciones

### Problema: "No se pueden crear eventos"
**Causa:** No hay calendarios en la cuenta del usuario

**Solución:**
```swift
// Ya implementado en AppointmentManager
let calendars = eventStore.calendars(for: .event)
if calendars.isEmpty {
    throw AppointmentError.noCalendarAvailable
}
```

**Para el usuario:**
- Ir a Ajustes > Calendario
- Añadir una cuenta (iCloud, Gmail, etc.)

### Problema: "Las alarmas no suenan"
**Causa 1:** Simulador no dispara alarmas (es normal)
**Solución:** Probar SOLO en iPhone real

**Causa 2:** "No Molestar" activado
**Solución:** Es comportamiento correcto del sistema

**Causa 3:** Calendario desactivado en Ajustes
**Solución:** Ajustes > Calendario > activar

### Problema: "El permiso no se pide"
**Causa:** Ya se pidió antes y el usuario denegó

**Solución:**
```swift
// Ya implementado: Verificar estado antes
let status = EKEventStore.authorizationStatus(for: .event)
if status == .denied {
    // Mostrar alerta: "Ve a Ajustes > Bitácora > Calendarios"
}
```

### Problema: "Notificaciones no llegan"
**Causa:** No se pidió permiso o está denegado

**Solución:**
- Verificar en Ajustes > Notificaciones > Bitácora
- Si está denegado, el usuario debe activarlo manualmente

---

## 📝 Info.plist OBLIGATORIO

**IMPORTANTE:** Sin esto, la app crasheará al pedir permiso de calendario.

Añadir al Info.plist:

```xml
<key>NSCalendarsFullAccessUsageDescription</key>
<string>Bitácora necesita acceso a tu calendario para crear recordatorios automáticos de tus citas recurrentes (psicólogo, médico, etc.) con alertas 1 día y 1 hora antes.</string>

<key>NSCalendarsWriteOnlyAccessUsageDescription</key>
<string>Bitácora necesita permiso para crear eventos de calendario para tus citas recurrentes.</string>
```

Ver `INFO_PLIST_INSTRUCTIONS.md` para más detalles.

---

## 🎨 UI/UX Highlights

### Diseño neutro y sin presión:
- ✅ NO hay rachas ni contadores
- ✅ NO hay mensajes de "llevas X días sin agendar"
- ✅ Botón "Aún no lo sé" siempre visible
- ✅ Las citas sin fecha NO desaparecen (sección "Sin fecha")
- ✅ Colores suaves y consistentes con el resto de la app

### Permisos explicados claramente:
- ✅ Sheet explicativo ANTES de pedir permiso
- ✅ Lista de beneficios (1 día antes, 1 hora antes, etc.)
- ✅ Dos opciones claras (Calendario vs Notificaciones)
- ✅ Sin jerga técnica

### Flujo rápido:
- ✅ "Ya fue" → Inmediatamente pregunta por la siguiente
- ✅ Mínimo de taps para completar acción
- ✅ DatePicker en modal (no full screen)

---

## 🔄 Arquitectura

### Separación de concerns:

```
┌─────────────────────────────────┐
│  AppointmentsView               │  ← UI y navegación
│  (SwiftUI)                      │
└────────────────┬────────────────┘
                 │
                 ↓
┌─────────────────────────────────┐
│  AppointmentManager             │  ← Lógica de negocio
│  (@Observable)                  │     y permisos
└────────────────┬────────────────┘
                 │
         ┌───────┴───────┐
         ↓               ↓
┌──────────────┐  ┌──────────────────┐
│  EventKit    │  │  UNNotifications │
│  (Sistema)   │  │  (Fallback)      │
└──────────────┘  └──────────────────┘
```

### SwiftData:
```
RecurringAppointment (modelo)
  ↓
SwiftData (persistencia)
  ↓
AppointmentsView (@Query)
```

---

## ✅ Compatibilidad

- **iOS 17+** (por `requestFullAccessToEvents`)
- **SwiftUI + SwiftData** (ya usados en el proyecto)
- **EventKit** (framework del sistema)
- **UserNotifications** (framework del sistema)

**Sin dependencias externas** ✅

---

## 🎯 Próximos pasos opcionales

### Mejoras futuras (no implementadas aún):

1. **Deep linking desde notificación:**
   - Tocar notificación post-cita abre directamente el sheet de próxima fecha
   - Requiere: `UNUserNotificationCenterDelegate` en `BitacoraApp`

2. **Widget de próximas citas:**
   - Muestra las 3 próximas citas en Home Screen
   - Requiere: WidgetKit extension

3. **Recordatorio inteligente:**
   - "Hace 2 meses que no vas al dentista, ¿quieres agendar?"
   - Lógica basada en `lastCompletedDate`

4. **Categorías de citas:**
   - "Salud mental", "Médico", "Otros"
   - Filtros por categoría

5. **Integración con DayEntry:**
   - Marcar automáticamente en la bitácora cuando es día de cita
   - Nota automática: "Hoy: Psicólogo a las 15:00"

---

## 📊 Estadísticas de código

### Líneas añadidas:
- **AppointmentManager.swift:** ~250 líneas
- **AppointmentsView.swift:** ~400 líneas
- **Localization.swift:** ~30 líneas nuevas
- **Localizable.xcstrings:** ~100 líneas nuevas
- **Modificaciones en archivos existentes:** ~50 líneas

**Total:** ~830 líneas de código

### Archivos afectados:
- Nuevos: 3 archivos Swift + 2 archivos documentación
- Modificados: 4 archivos Swift + 1 JSON

---

## 🎉 Conclusión

Sistema completo de citas recurrentes implementado con:

✅ Modelo de datos robusto  
✅ Integración EventKit (preferida)  
✅ Fallback con UNNotifications  
✅ UI minimalista y sin presión  
✅ Menú dinámico configurable  
✅ Localización completa ES/EN  
✅ Flujo de permisos explicado  
✅ Notificación post-cita para agendar siguiente  
✅ Preparado para futuras extensiones  

**¡Listo para compilar y probar en iPhone!** 🚀

---

**Última actualización:** Septiembre 2026  
**Versión:** 1.2.0
