import Foundation
import EventKit
import UserNotifications
import SwiftUI

// MARK: - Manager de citas con integración EventKit + UNNotifications

@Observable
class AppointmentManager {
    private let eventStore = EKEventStore()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    var calendarPermissionStatus: CalendarPermissionStatus = .notAsked
    var notificationPermissionStatus: UNAuthorizationStatus = .notDetermined
    
    // MARK: - Permisos
    
    /// Verifica el estado actual de permisos de calendario
    func checkCalendarPermission() {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .notDetermined:
            calendarPermissionStatus = .notAsked
        case .restricted, .denied:
            calendarPermissionStatus = .denied
        case .fullAccess:
            calendarPermissionStatus = .fullAccess
        case .writeOnly:
            calendarPermissionStatus = .writeOnly
        @unknown default:
            calendarPermissionStatus = .notAsked
        }
    }
    
    /// Pide permiso de calendario (full access preferido)
    @MainActor
    func requestCalendarAccess() async -> Bool {
        do {
            let granted = try await eventStore.requestFullAccessToEvents()
            checkCalendarPermission()
            return granted
        } catch {
            print("Error requesting calendar access: \(error)")
            // Intentar write-only como fallback
            do {
                let granted = try await eventStore.requestWriteOnlyAccessToEvents()
                checkCalendarPermission()
                return granted
            } catch {
                print("Error requesting write-only access: \(error)")
                checkCalendarPermission()
                return false
            }
        }
    }
    
    /// Pide permiso de notificaciones locales (fallback)
    @MainActor
    func requestNotificationAccess() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            let settings = await notificationCenter.notificationSettings()
            notificationPermissionStatus = settings.authorizationStatus
            return granted
        } catch {
            print("Error requesting notification access: \(error)")
            return false
        }
    }
    
    // MARK: - EventKit (Calendario)
    
    /// Crea un evento en el calendario con 2 alarmas
    func createCalendarEvent(for appointment: RecurringAppointment) async throws -> String {
        guard calendarPermissionStatus == .fullAccess || calendarPermissionStatus == .writeOnly else {
            throw AppointmentError.noCalendarPermission
        }
        
        guard let nextDate = appointment.nextDate else {
            throw AppointmentError.noDateSet
        }
        
        guard let calendar = eventStore.defaultCalendarForNewEvents else {
            throw AppointmentError.noCalendarAvailable
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = appointment.title
        event.notes = appointment.notes.isEmpty ? nil : appointment.notes
        event.startDate = nextDate
        event.endDate = nextDate.addingTimeInterval(3600) // 1 hora de duración
        event.calendar = calendar
        
        // Alarma 1: 1 día antes
        let dayBeforeAlarm = EKAlarm(relativeOffset: -86400) // -24 horas
        event.addAlarm(dayBeforeAlarm)
        
        // Alarma 2: 1 hora antes
        let hourBeforeAlarm = EKAlarm(relativeOffset: -3600) // -1 hora
        event.addAlarm(hourBeforeAlarm)
        
        try eventStore.save(event, span: .thisEvent, commit: true)
        
        // Programar notificación post-cita (2 horas después)
        await schedulePostAppointmentNotification(for: appointment, eventDate: nextDate)
        
        return event.eventIdentifier
    }
    
    /// Actualiza un evento existente
    func updateCalendarEvent(for appointment: RecurringAppointment) async throws {
        guard let eventIdentifier = appointment.eventKitIdentifier else {
            // No hay evento previo, crear uno nuevo
            let newIdentifier = try await createCalendarEvent(for: appointment)
            // Nota: El caller debe actualizar appointment.eventKitIdentifier
            return
        }
        
        guard let event = eventStore.event(withIdentifier: eventIdentifier) else {
            // El evento fue borrado externamente, crear uno nuevo
            let newIdentifier = try await createCalendarEvent(for: appointment)
            return
        }
        
        guard let nextDate = appointment.nextDate else {
            // Si ya no hay fecha, borrar el evento
            try await deleteCalendarEvent(identifier: eventIdentifier)
            return
        }
        
        // Actualizar evento existente
        event.title = appointment.title
        event.notes = appointment.notes.isEmpty ? nil : appointment.notes
        event.startDate = nextDate
        event.endDate = nextDate.addingTimeInterval(3600)
        
        // Limpiar alarmas viejas
        if let alarms = event.alarms {
            for alarm in alarms {
                event.removeAlarm(alarm)
            }
        }
        
        // Añadir alarmas nuevas
        event.addAlarm(EKAlarm(relativeOffset: -86400)) // 1 día antes
        event.addAlarm(EKAlarm(relativeOffset: -3600))  // 1 hora antes
        
        try eventStore.save(event, span: .thisEvent, commit: true)
        
        // Actualizar notificación post-cita
        await schedulePostAppointmentNotification(for: appointment, eventDate: nextDate)
    }
    
    /// Borra un evento del calendario
    func deleteCalendarEvent(identifier: String) async throws {
        guard let event = eventStore.event(withIdentifier: identifier) else {
            // Ya no existe, no hacer nada
            return
        }
        
        try eventStore.remove(event, span: .thisEvent, commit: true)
    }
    
    // MARK: - Notificaciones locales (Fallback)
    
    /// Programa notificaciones locales si no hay permiso de calendario
    func scheduleLocalNotifications(for appointment: RecurringAppointment) async throws {
        guard notificationPermissionStatus == .authorized else {
            throw AppointmentError.noNotificationPermission
        }
        
        guard let nextDate = appointment.nextDate else {
            throw AppointmentError.noDateSet
        }
        
        // Cancelar notificaciones previas de esta cita
        await cancelLocalNotifications(for: appointment)
        
        let calendar = Calendar.current
        
        // Notificación 1: 1 día antes
        if let dayBefore = calendar.date(byAdding: .day, value: -1, to: nextDate) {
            let content = UNMutableNotificationContent()
            content.title = "Recordatorio: \(appointment.title)"
            content.body = "Mañana tienes cita: \(appointment.title)"
            content.sound = .default
            
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dayBefore)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "\(appointment.id.uuidString)-dayBefore",
                content: content,
                trigger: trigger
            )
            
            try await notificationCenter.add(request)
        }
        
        // Notificación 2: 1 hora antes
        if let hourBefore = calendar.date(byAdding: .hour, value: -1, to: nextDate) {
            let content = UNMutableNotificationContent()
            content.title = "¡En 1 hora!"
            content.body = "Tu cita de \(appointment.title) es en 1 hora"
            content.sound = .default
            
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: hourBefore)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "\(appointment.id.uuidString)-hourBefore",
                content: content,
                trigger: trigger
            )
            
            try await notificationCenter.add(request)
        }
        
        // Notificación post-cita
        await schedulePostAppointmentNotification(for: appointment, eventDate: nextDate)
    }
    
    /// Programa notificación post-cita (2 horas después)
    private func schedulePostAppointmentNotification(for appointment: RecurringAppointment, eventDate: Date) async {
        let calendar = Calendar.current
        guard let twoHoursAfter = calendar.date(byAdding: .hour, value: 2, to: eventDate) else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "¿Ya terminó tu cita?"
        content.body = "¿Cuándo es la próxima cita de \(appointment.title)? Toca para agendar 📅"
        content.sound = .default
        content.categoryIdentifier = "APPOINTMENT_COMPLETED"
        content.userInfo = ["appointmentId": appointment.id.uuidString]
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: twoHoursAfter)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "\(appointment.id.uuidString)-postAppointment",
            content: content,
            trigger: trigger
        )
        
        try? await notificationCenter.add(request)
    }
    
    /// Cancela notificaciones locales de una cita
    func cancelLocalNotifications(for appointment: RecurringAppointment) async {
        let identifiers = [
            "\(appointment.id.uuidString)-dayBefore",
            "\(appointment.id.uuidString)-hourBefore",
            "\(appointment.id.uuidString)-postAppointment"
        ]
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    // MARK: - Helpers
    
    /// Maneja una cita completa: guarda evento en calendario O notificaciones locales
    func scheduleAppointment(_ appointment: RecurringAppointment) async throws -> String? {
        if calendarPermissionStatus == .fullAccess || calendarPermissionStatus == .writeOnly {
            return try await createCalendarEvent(for: appointment)
        } else if notificationPermissionStatus == .authorized {
            try await scheduleLocalNotifications(for: appointment)
            return nil // No hay eventIdentifier
        } else {
            throw AppointmentError.noPermissions
        }
    }
}

// MARK: - Estados y errores

enum CalendarPermissionStatus {
    case notAsked
    case denied
    case writeOnly
    case fullAccess
}

enum AppointmentError: LocalizedError {
    case noCalendarPermission
    case noNotificationPermission
    case noPermissions
    case noDateSet
    case noCalendarAvailable
    
    var errorDescription: String? {
        switch self {
        case .noCalendarPermission:
            return "No tienes permiso de calendario"
        case .noNotificationPermission:
            return "No tienes permiso de notificaciones"
        case .noPermissions:
            return "Necesitas dar permiso de calendario o notificaciones"
        case .noDateSet:
            return "La cita no tiene fecha programada"
        case .noCalendarAvailable:
            return "No hay calendarios disponibles. Añade una cuenta en Ajustes > Calendario"
        }
    }
}
