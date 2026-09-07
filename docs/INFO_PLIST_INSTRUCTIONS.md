# Info.plist - Claves necesarias para Citas

Añade estas claves al Info.plist de tu proyecto:

## Permisos de Calendario (EventKit)

### Full Access (iOS 17+)
```xml
<key>NSCalendarsFullAccessUsageDescription</key>
<string>Bitácora necesita acceso a tu calendario para crear recordatorios automáticos de tus citas recurrentes (psicólogo, médico, etc.) con alertas 1 día y 1 hora antes.</string>
```

**Traducción EN:**
```
Bitácora needs access to your calendar to create automatic reminders for your recurring appointments (therapist, doctor, etc.) with alerts 1 day and 1 hour before.
```

### Write-Only Access (fallback)
```xml
<key>NSCalendarsWriteOnlyAccessUsageDescription</key>
<string>Bitácora necesita permiso para crear eventos de calendario para tus citas recurrentes.</string>
```

**Traducción EN:**
```
Bitácora needs permission to create calendar events for your recurring appointments.
```

---

## Cómo añadir al proyecto:

1. **En Xcode:** Abre el archivo `Info.plist` de tu target
2. **Clic derecho** en cualquier parte > "Add Row"
3. **Pega la clave** `NSCalendarsFullAccessUsageDescription`
4. **Pega el valor** (la descripción en español)
5. **Repite** para `NSCalendarsWriteOnlyAccessUsageDescription`

O bien:

1. **Abre Info.plist como "Source Code"** (clic derecho > Open As > Source Code)
2. **Pega** estas líneas dentro de `<dict>...</dict>`:

```xml
<key>NSCalendarsFullAccessUsageDescription</key>
<string>Bitácora necesita acceso a tu calendario para crear recordatorios automáticos de tus citas recurrentes (psicólogo, médico, etc.) con alertas 1 día y 1 hora antes.</string>

<key>NSCalendarsWriteOnlyAccessUsageDescription</key>
<string>Bitácora necesita permiso para crear eventos de calendario para tus citas recurrentes.</string>
```

---

## Verificación:

Después de añadir las claves:

1. **Clean Build Folder** (Cmd + Shift + K)
2. **Build** (Cmd + B)
3. **Run en iPhone** (Cmd + R)
4. **Al crear primera cita con fecha:** Debe aparecer el diálogo del sistema pidiendo permiso

Si no aparece el diálogo, revisa que las claves estén bien escritas (sin espacios extra, dentro del `<dict>` principal).

---

## Permisos de Notificaciones

NO necesitas añadir nada al Info.plist para `UNUserNotificationCenter`. 
El permiso se pide automáticamente con `requestAuthorization` en código.
