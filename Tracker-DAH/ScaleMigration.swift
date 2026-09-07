import Foundation
import SwiftData

// MARK: - Migración de escala 0-10 a 1-5

/// Migra una sola vez la puntuación antigua (0-10) a la nueva (1-5).
/// Se ejecuta automáticamente al arrancar si no se ha hecho antes.
@MainActor
struct ScaleMigration {
    private static let didMigrateKey = "didMigrateToFiveScale"
    
    /// Comprueba si ya se migró.
    static var alreadyMigrated: Bool {
        UserDefaults.standard.bool(forKey: didMigrateKey)
    }
    
    /// Ejecuta la migración si no se hizo antes.
    static func migrateIfNeeded(context: ModelContext) async throws {
        guard !alreadyMigrated else { return }
        
        print("🔄 Iniciando migración de escala 0-10 → 1-5...")
        
        // 1. Hacer backup antes de migrar
        try await createBackup(context: context)
        
        // 2. Obtener todos los DayEntry
        let descriptor = FetchDescriptor<DayEntry>(sortBy: [SortDescriptor(\.date)])
        let entries = try context.fetch(descriptor)
        
        var migratedCount = 0
        
        // 3. Convertir cada valor
        for entry in entries {
            var changed = false
            
            if let oldMood = entry.mood {
                entry.mood = convertOldToNew(oldMood)
                changed = true
            }
            
            if let oldEnergy = entry.energy {
                entry.energy = convertOldToNew(oldEnergy)
                changed = true
            }
            
            if let oldFocus = entry.focus {
                entry.focus = convertOldToNew(oldFocus)
                changed = true
            }
            
            if let oldSleep = entry.sleep {
                entry.sleep = convertOldToNew(oldSleep)
                changed = true
            }
            
            if changed {
                migratedCount += 1
            }
        }
        
        // 4. Guardar cambios
        try context.save()
        
        // 5. Marcar como migrado
        UserDefaults.standard.set(true, forKey: didMigrateKey)
        
        print("✅ Migración completada: \(migratedCount) días actualizados")
    }
    
    /// Convierte un valor antiguo (0-10) al nuevo rango (1-5)
    /// Fórmula: max(1, round(old / 2))
    private static func convertOldToNew(_ oldValue: Int) -> Int {
        // Si el valor ya está en rango 1-5, no hacer nada
        if oldValue >= 1 && oldValue <= 5 {
            return oldValue
        }
        
        // Convertir 0-10 → 1-5
        let converted = max(1, Int((Double(oldValue) / 2.0).rounded()))
        return min(5, converted) // Asegurar que no se pase de 5
    }
    
    /// Crea un backup en JSON en el directorio Documents
    private static func createBackup(context: ModelContext) async throws {
        let descriptor = FetchDescriptor<DayEntry>(sortBy: [SortDescriptor(\.date)])
        let entries = try context.fetch(descriptor)
        
        // Crear estructura de backup
        let backup = BackupData(
            version: "pre-five-scale-migration",
            date: Date(),
            entries: entries.map { entry in
                BackupEntry(
                    date: entry.date,
                    mood: entry.mood,
                    energy: entry.energy,
                    focus: entry.focus,
                    sleep: entry.sleep
                )
            }
        )
        
        // Guardar en Documents
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(backup)
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let backupURL = documentsURL.appendingPathComponent("bitacora-backup-\(dateString()).json")
        
        try data.write(to: backupURL)
        
        print("💾 Backup creado en: \(backupURL.path)")
    }
    
    private static func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HHmmss"
        return formatter.string(from: Date())
    }
}

// MARK: - Estructuras de backup

private struct BackupData: Codable {
    let version: String
    let date: Date
    let entries: [BackupEntry]
}

private struct BackupEntry: Codable {
    let date: Date
    let mood: Int?
    let energy: Int?
    let focus: Int?
    let sleep: Int?
}
