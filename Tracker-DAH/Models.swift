import Foundation
import SwiftData

// MARK: - Un día de la bitácora

@Model
final class DayEntry {
    /// Siempre normalizada a las 00:00 del día (ver Calendar.startOfDay)
    @Attribute(.unique) var date: Date

    var wakeTime: Date?
    var medTime: Date?
    var medNotes: String = ""

    var sleep: Int?
    var mood: Int?
    var energy: Int?
    var focus: Int?

    var didGym: Bool = false
    var gymType: String = ""

    var floss: Bool = false
    var alcohol: Bool = false
    var alcoholDetail: String = ""
    var meditated: Bool = false
    var meditationMinutes: Int?
    var didRead: Bool = false
    var readingMinutes: Int?
    var screensBeforeBed: Bool = false
    var screenMinutes: Int?

    var notes: String = ""

    @Relationship(deleteRule: .cascade, inverse: \ActivityItem.entry)
    var activities: [ActivityItem] = []

    init(date: Date) {
        self.date = Calendar.current.startOfDay(for: date)
    }

    /// Actividades en el orden en que las escribió el usuario
    var sortedActivities: [ActivityItem] {
        activities.sorted { $0.order < $1.order }
    }

    /// ¿Hay algo apuntado? Sirve para no dejar días vacíos por ahí.
    var isEmpty: Bool {
        wakeTime == nil && medTime == nil && medNotes.isEmpty
            && sleep == nil && mood == nil && energy == nil && focus == nil
            && !didGym && gymType.isEmpty
            && !floss && !alcohol && !meditated && !didRead && !screensBeforeBed
            && notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && activities.allSatisfy { $0.isEmpty }
    }
}

// MARK: - Una actividad suelta dentro del día

@Model
final class ActivityItem {
    var time: String = ""
    var text: String = ""
    var order: Int = 0
    var entry: DayEntry?

    init(time: String = "", text: String = "", order: Int = 0) {
        self.time = time
        self.text = text
        self.order = order
    }

    var isEmpty: Bool {
        time.trimmingCharacters(in: .whitespaces).isEmpty
            && text.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
// MARK: - Cita recurrente sin fecha fija

@Model
final class RecurringAppointment {
    @Attribute(.unique) var id: UUID
    var title: String
    var nextDate: Date?
    var lastCompletedDate: Date?
    var notes: String
    var eventKitIdentifier: String?
    
    init(
        id: UUID = UUID(),
        title: String,
        nextDate: Date? = nil,
        lastCompletedDate: Date? = nil,
        notes: String = "",
        eventKitIdentifier: String? = nil
    ) {
        self.id = id
        self.title = title
        self.nextDate = nextDate
        self.lastCompletedDate = lastCompletedDate
        self.notes = notes
        self.eventKitIdentifier = eventKitIdentifier
    }
    
    /// ¿Tiene fecha programada?
    var isScheduled: Bool {
        nextDate != nil
    }
    
    /// ¿Es hoy o en el pasado?
    var isPastDue: Bool {
        guard let date = nextDate else { return false }
        return date <= Date()
    }
}

