import Foundation

// MARK: - Sistema de localización optimizado

enum L10n {
    /// Helper para reducir boilerplate en las localizaciones.
    /// `key` tiene que ser `StaticString` (literal fijo) porque así lo exige el
    /// overload de `String(localized:defaultValue:)`: es lo que permite a Xcode
    /// extraer automáticamente las claves al String Catalog.
    private static func string(_ key: StaticString, _ default: String) -> String {
        String(localized: key, defaultValue: String.LocalizationValue(`default`))
    }
    
    // MARK: - Tabs
    static let tabJournal = string("tab.journal", "Bitácora")
    static let tabSummary = string("tab.summary", "Resumen")
    static let tabCharts = string("tab.charts", "Gráficas")
    
    // MARK: - Sections
    static let sectionSleep = string("section.sleep", "Sueño y medicación")
    static let sectionFeelings = string("section.feelings", "Cómo te sientes")
    static let sectionActivities = string("section.activities", "Actividades del día")
    static let sectionGym = string("section.gym", "Gimnasio")
    static let sectionHabits = string("section.habits", "Hábitos")
    static let sectionNotes = string("section.notes", "Notas del día")
    
    // MARK: - Common
    static let settings = string("common.settings", "Configuración")
    static let export = string("common.export", "Exportar")
    static let today = string("common.today", "Hoy")
    static let done = string("common.done", "Listo")
    static let add = string("common.add", "Añadir")
    static let remove = string("common.remove", "Eliminar")
    static let cancel = string("common.cancel", "Cancelar")
    
    // MARK: - Metrics
    static let mood = string("metric.mood", "Ánimo")
    static let energy = string("metric.energy", "Energía")
    static let focus = string("metric.focus", "Foco")
    static let sleep = string("metric.sleep", "Sueño")
    
    // MARK: - Rating labels
    static let ratingLow = string("rating.low", "Mal")
    static let ratingHigh = string("rating.high", "Bien")
    static let rating1 = string("rating.1", "Mal")
    static let rating2 = string("rating.2", "Bueno")
    static let rating3 = string("rating.3", "Normal")
    static let rating4 = string("rating.4", "Bien")
    static let rating5 = string("rating.5", "Muy bien")
    
    // MARK: - Sleep & Medication
    static let wakeTime = string("sleep.wakeTime", "Hora de despertar")
    static let sleepQuality = string("sleep.quality", "Calidad del sueño")
    static let medicationTime = string("medication.time", "Hora de la medicación")
    static let medicationNotes = string("medication.notes", "Notas sobre la medicación")
    static let showMedication = string("medication.show", "Mostrar medicación")
    static let includeMedicationFields = string("medication.include", "Incluir campos de medicación")
    
    // MARK: - Habits
    static let floss = string("habit.floss", "Hilo dental")
    static let alcohol = string("habit.alcohol", "Alcohol")
    static let meditation = string("habit.meditation", "Meditación")
    static let reading = string("habit.reading", "Lectura")
    static let screens = string("habit.screens", "Pantallas antes de dormir")
    
    // MARK: - Settings - General
    static let defaultHabits = string("settings.defaultHabits", "Hábitos predeterminados")
    static let enableDisableHabits = string("settings.enableDisableHabits", "Activa o desactiva los hábitos que quieres seguir")
    static let visibleSections = string("settings.visibleSections", "Secciones visibles")
    static let hideSections = string("settings.hideSections", "Oculta las secciones que no uses")
    static let expandedSections = string("settings.expandedSections", "Secciones expandidas")
    static let chooseDefaultExpanded = string("settings.chooseDefaultExpanded", "Elige qué secciones quieres ver abiertas por defecto")
    static let resetPreferences = string("settings.resetPreferences", "Restablecer preferencias")
    
    // MARK: - Settings - Presets
    static let settingsPresets = string("settings.presets", "Configuraciones rápidas")
    static let settingsPresetsDescription = string("settings.presets.description", "Aplica una configuración predefinida con un toque")
    static let settingsPresetMinimalist = string("settings.preset.minimalist", "Minimalista")
    static let settingsPresetMinimalistDescription = string("settings.preset.minimalist.description", "Solo lo esencial: sueño y ánimo")
    static let settingsPresetComplete = string("settings.preset.complete", "Completa")
    static let settingsPresetCompleteDescription = string("settings.preset.complete.description", "Todo visible y abierto")
    static let settingsPresetNoMedication = string("settings.preset.noMedication", "Sin medicación")
    static let settingsPresetNoMedicationDescription = string("settings.preset.noMedication.description", "Enfoque en hábitos generales")
    
    // MARK: - Settings - Sections
    static let settingsSections = string("settings.sections", "Secciones")
    static let settingsSectionsDescription = string("settings.sections.description", "Oculta, cierra o abre cada sección por defecto")
    static let settingsStateHidden = string("settings.state.hidden", "Oculta")
    static let settingsStateCollapsed = string("settings.state.collapsed", "Cerrada")
    static let settingsStateExpanded = string("settings.state.expanded", "Abierta")
    
    // MARK: - Settings - Advanced
    static let settingsAdvanced = string("settings.advanced", "Opciones avanzadas")
    static let settingsMedication = string("settings.medication", "Medicación")
    static let settingsCustomHabits = string("settings.customHabits", "Hábitos personalizados")
    static let settingsCustomHabitsDescription = string("settings.customHabits.description", "Añade tus propios hábitos para hacer seguimiento")
    static let settingsAddCustomHabit = string("settings.addCustomHabit", "Añadir hábito personalizado")
    static let settingsNewHabit = string("settings.newHabit", "Nuevo hábito")
    static let settingsHabitName = string("settings.habitName", "Nombre del hábito")
    static let settingsHabitNamePlaceholder = string("settings.habitName.placeholder", "Ejemplo: Tomar vitaminas")
    static let settingsHabitIcon = string("settings.habitIcon", "Icono")
    static let settingsSaveHabit = string("settings.saveHabit", "Guardar hábito")
    static let settingsVersion = string("settings.version", "Versión 1.0.0")
    
    // MARK: - Gym
    static let didGym = string("gym.did", "¿Fuiste al gimnasio?")
    
    // MARK: - Charts
    static let analysis = string("charts.analysis", "Análisis")
    static let weeklySummary = string("charts.weeklySummary", "Resumen semanal")
    static let noDataYet = string("charts.noData", "Sin datos todavía")
    static let startFilling = string("charts.startFilling", "Empieza a rellenar tu bitácora diaria")
    static let noNotesWeek = string("charts.noNotes", "No hay notas esta semana")
    static let habitStreaks = string("charts.habitStreaks", "Rachas de hábitos")
    static let statistics = string("charts.statistics", "Estadísticas")
    static let average = string("charts.average", "Promedio")
    static let maximum = string("charts.maximum", "Máximo")
    static let minimum = string("charts.minimum", "Mínimo")
    
    // MARK: - Appointments
    static let appointments = string("appointments.title", "Citas")
    static let appointmentsUpcoming = string("appointments.upcoming", "Próximas")
    static let appointmentsUnscheduled = string("appointments.unscheduled", "Sin fecha")
    static let appointmentsEmpty = string("appointments.empty", "No tienes citas")
    static let appointmentsEmptyDescription = string("appointments.empty.description", "Toca + para añadir tu primera cita recurrente")
    static let appointmentsCompleted = string("appointments.completed", "Ya fue")
    static let appointmentsNoDate = string("appointments.noDate", "Sin fecha programada")
    static let appointmentsTitle = string("appointments.appointmentTitle", "Título")
    static let appointmentsNotes = string("appointments.notes", "Notas")
    static let appointmentsNewAppointment = string("appointments.new", "Nueva cita")
    static let appointmentsScheduleNow = string("appointments.scheduleNow", "Programar ahora")
    static let appointmentsDate = string("appointments.date", "Fecha y hora")
    static let appointmentsCreate = string("appointments.create", "Crear cita")
    static let appointmentsSchedule = string("appointments.schedule", "Programar")
    static let appointmentsDontKnow = string("appointments.dontKnow", "Aún no lo sé")
    
    static func appointmentsNextQuestion(_ title: String) -> String {
        String(localized: "¿Cuándo es la próxima cita de \(title)?")
    }
    
    // MARK: - Appointment Permissions
    static let appointmentsPermissionTitle = string("appointments.permission.title", "Recordatorios de citas")
    static let appointmentsPermissionDescription = string("appointments.permission.description", "Para no olvidar tus citas, Bitácora puede agregarlas a tu Calendario con alertas automáticas.")
    static let appointmentsPermission1Day = string("appointments.permission.1day", "1 día antes")
    static let appointmentsPermission1Hour = string("appointments.permission.1hour", "1 hora antes")
    static let appointmentsPermissionAfter = string("appointments.permission.after", "2 horas después (para agendar la siguiente)")
    static let appointmentsPermissionGrant = string("appointments.permission.grant", "Dar acceso al Calendario")
    static let appointmentsPermissionNotificationsOnly = string("appointments.permission.notificationsOnly", "Solo notificaciones locales")
    
    // MARK: - Menu
    static let menu = string("menu.title", "Menú")
    static let menuOptions = string("menu.options", "Opciones del menú")
    static let menuOptionsDescription = string("menu.options.description", "Elige qué opciones aparecen en el menú principal")
    static let showAppointmentsInMenu = string("menu.showAppointments", "Mostrar Citas en el menú")
    
    // MARK: - Notifications
    static let notificationsTitle = string("notifications.title", "Notificaciones")
    static let notificationsDescription = string("notifications.description", "Configura los recordatorios para tus citas")
    static let notificationsStatus = string("notifications.status", "Estado de notificaciones")
    static let notificationsEnabled = string("notifications.enabled", "Activadas")
    static let notificationsDisabled = string("notifications.disabled", "Desactivadas")
    static let notificationsOpenSettings = string("notifications.openSettings", "Abrir Configuración")
}
