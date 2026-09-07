# 🚀 Guía Rápida de Implementación - Sistema de Citas

## ⚡ Pasos para añadir al proyecto (15 minutos)

### 1️⃣ Añadir archivos nuevos a Xcode

**Arrastra estos archivos al proyecto:**
- ✅ `AppointmentManager.swift`
- ✅ `AppointmentsView.swift`  
- ✅ `Localization.swift`
- ✅ `Localizable.xcstrings` (reemplazar el existente)

**Asegúrate de:**
- ☑️ Marcar "Copy items if needed"
- ☑️ Marcar tu Target en "Target Membership"

---

### 2️⃣ Reemplazar archivos modificados

**Estos archivos tienen cambios, reemplázalos:**
- ✅ `Models.swift` - Añadido `RecurringAppointment`
- ✅ `DayView.swift` - Menú dinámico con ellipsis.circle
- ✅ `SettingsView.swift` - Nueva sección "Opciones del menú"
- ✅ `BitacoraApp.swift` - Añadido `RecurringAppointment` al modelContainer

---

### 3️⃣ Añadir permisos al Info.plist

**Método A: Desde el editor visual**

1. Abre tu proyecto en Xcode
2. Selecciona tu Target
3. Pestaña "Info"
4. Clic derecho > "Add Row"
5. Añadir clave: `NSCalendarsFullAccessUsageDescription`
6. Valor: `Bitácora necesita acceso a tu calendario para crear recordatorios automáticos de tus citas recurrentes (psicólogo, médico, etc.) con alertas 1 día y 1 hora antes.`
7. Repetir para: `NSCalendarsWriteOnlyAccessUsageDescription`
8. Valor: `Bitácora necesita permiso para crear eventos de calendario para tus citas recurrentes.`

**Método B: Como código fuente**

1. Clic derecho en Info.plist > "Open As" > "Source Code"
2. Pegar dentro de `<dict>...</dict>`:

```xml
<key>NSCalendarsFullAccessUsageDescription</key>
<string>Bitácora necesita acceso a tu calendario para crear recordatorios automáticos de tus citas recurrentes (psicólogo, médico, etc.) con alertas 1 día y 1 hora antes.</string>

<key>NSCalendarsWriteOnlyAccessUsageDescription</key>
<string>Bitácora necesita permiso para crear eventos de calendario para tus citas recurrentes.</string>
```

---

### 4️⃣ Compilar y ejecutar

```bash
# Limpiar build
Cmd + Shift + K

# Compilar
Cmd + B

# Ejecutar en iPhone
Cmd + R
```

**Si hay errores de compilación:**
- Verifica que todos los archivos estén en el Target
- Clean Build Folder (Cmd + Shift + K)
- Restart Xcode

---

### 5️⃣ Probar en iPhone

#### Primera prueba básica:

1. **Abrir menú:**
   - Toca el icono de 3 puntos (ellipsis.circle) arriba a la derecha
   - Verifica que aparece "Configuración" y "Citas"

2. **Crear primera cita:**
   - Menú > Citas
   - Toca el botón "+"
   - Escribe título: "Prueba"
   - Activa "Programar ahora"
   - Selecciona fecha dentro de 1 hora
   - Toca "Crear cita"

3. **Permisos:**
   - Debe aparecer sheet explicativo
   - Toca "Dar acceso al Calendario"
   - iOS pedirá permiso (diálogo del sistema)
   - Toca "Permitir" o "Permitir acceso completo"

4. **Verificar evento creado:**
   - Abre app Calendario del iPhone
   - Busca tu evento "Prueba"
   - Toca para editar
   - Verifica que tiene 2 alarmas:
     - 1 día antes
     - 1 hora antes

5. **Completar cita:**
   - Vuelve a Bitácora > Menú > Citas
   - Toca "Ya fue" en la cita
   - Debe aparecer sheet: "¿Cuándo es la próxima cita de Prueba?"
   - Selecciona otra fecha
   - Toca "Programar"
   - Verifica que se actualiza

6. **Ocultar del menú:**
   - Menú > Configuración
   - Scroll hasta "Opciones del menú"
   - Desactiva "Mostrar Citas en el menú"
   - Vuelve atrás
   - Abre el menú de nuevo
   - "Citas" debe haber desaparecido ✅

---

## 🐛 Solución de problemas

### Error: "Cannot find 'RecurringAppointment' in scope"

**Solución:**
- Verifica que `Models.swift` tenga el modelo `RecurringAppointment`
- Verifica que esté en el Target
- Clean Build Folder (Cmd + Shift + K)

---

### Error: "Cannot find 'L10n' in scope"

**Solución:**
- Verifica que `Localization.swift` esté en el proyecto
- Verifica Target Membership
- Clean Build

---

### Error: "App crashes al pedir permiso de calendario"

**Solución:**
- Verifica que añadiste las claves al Info.plist
- Deben estar DENTRO de `<dict>...</dict>`
- Las claves deben ser exactamente:
  - `NSCalendarsFullAccessUsageDescription`
  - `NSCalendarsWriteOnlyAccessUsageDescription`

---

### Error: "El evento no aparece en Calendario"

**Solución:**
- Verifica que diste permiso de calendario
- Abre Ajustes > Bitácora > Calendarios > debe estar activado
- Verifica que tienes al menos una cuenta de calendario configurada
  - Ajustes > Calendario > Cuentas > debe haber al menos una

---

### Las alarmas no suenan

**Causa 1: Simulador**
- Simulador NO dispara alarmas del calendario
- Probar SOLO en iPhone real

**Causa 2: "No Molestar" activado**
- Es comportamiento normal
- Las alarmas se mostrarán cuando se desactive

**Causa 3: Calendario desactivado**
- Ajustes > Calendario > activar

---

### Menu no aparece

**Solución:**
- Verifica que `DayView.swift` tenga el código del Menu
- Busca: `Menu { ... } label: { Image(systemName: "ellipsis.circle") }`
- Si no está, reemplaza el archivo completo

---

### "Citas" no aparece en el menú

**Solución:**
- Ve a Configuración > Opciones del menú
- Verifica que "Mostrar Citas en el menú" esté activado
- Si está activado y no aparece, reinicia la app

---

## ✅ Checklist final

Antes de dar por terminado:

- [ ] Info.plist tiene las 2 claves de calendario
- [ ] Todos los archivos nuevos están en el proyecto
- [ ] Todos los archivos tienen Target Membership
- [ ] Compilar sin errores
- [ ] Ejecutar en iPhone real (no simulador)
- [ ] Menú aparece con ellipsis.circle
- [ ] "Citas" aparece en el menú
- [ ] Puedo crear una cita
- [ ] Sheet de permisos aparece
- [ ] Permiso de calendario funciona
- [ ] Evento aparece en app Calendario
- [ ] Evento tiene 2 alarmas
- [ ] Botón "Ya fue" funciona
- [ ] Sheet de próxima fecha funciona
- [ ] Puedo ocultar "Citas" desde Configuración
- [ ] Swipe to delete funciona
- [ ] App en español funciona
- [ ] App en inglés funciona (cambiar idioma del iPhone)

---

## 📱 Testing avanzado (opcional)

### Probar notificación post-cita:

**Opción A: Esperar tiempo real**
1. Crear cita para dentro de 10 minutos
2. Esperar 2 horas y 10 minutos
3. Debe llegar notificación "¿Ya terminó tu cita?"

**Opción B: Modificar código para testing rápido**
En `AppointmentManager.swift`, línea ~145:
```swift
// ANTES:
guard let twoHoursAfter = calendar.date(byAdding: .hour, value: 2, to: eventDate)

// CAMBIAR A (solo para testing):
guard let twoHoursAfter = calendar.date(byAdding: .minute, value: 2, to: eventDate)
```

Ahora la notificación llegará 2 minutos después en vez de 2 horas.
**¡Recuerda volver a cambiar a 2 horas para producción!**

---

### Probar fallback de notificaciones locales:

1. **Denegar** permiso de calendario
2. Crear cita con fecha
3. Debe pedir permiso de notificaciones
4. Dar permiso
5. Ir a Ajustes > Notificaciones > Bitácora
6. Verificar que hay notificaciones pendientes

---

### Probar en inglés:

1. iPhone > Settings > General > Language & Region
2. iPhone Language > English
3. Confirmar (iPhone reiniciará)
4. Abrir app
5. Todo debe estar en inglés ✅

---

## 🎉 ¡Listo!

Si todos los checks están marcados, el sistema de citas está completamente implementado y funcional.

**Disfruta tu nueva funcionalidad de citas recurrentes!** 📅✨

---

**Documentación adicional:**
- `APPOINTMENTS_IMPLEMENTATION.md` - Detalles técnicos completos
- `INFO_PLIST_INSTRUCTIONS.md` - Guía de permisos
- `Localizable.xcstrings` - Todas las traducciones

**Versión:** 1.2.0  
**Fecha:** Septiembre 2026
