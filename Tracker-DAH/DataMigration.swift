import Foundation
import SwiftData

// MARK: - Migración de escala 0–10 a 1–5

enum DataMigration {
    
    /// Key para saber si ya se ejecutó la migración
    private static let migrationKey = "didMigrateToFiveScale"
    
    /// Verifica si ya se ejecutó la migración
    static func needsMigration() -> Bool {
        !UserDefaults.standard.bool(forKey: migrationKey)
    }
    
    /// Ejecuta la migración de escala 0-10 a 1-5
    /// - Hace backup automático a JSON antes de migrar
    /// - Convierte todos los valores con la fórmula: max(1, round(old / 2.0))
    /// - Los nil se mantienen nil
    @MainActor
    static func migrateToFiveScale(context: ModelContext) async throws {
        guard needsMigration() else {
            print("✅ Migración ya ejecutada anteriormente")
            return
        }
        
        print("🔄 Iniciando migración de escala 0-10 → 1-5...")
        
        // 1. Obtener todas las entradas
        let descriptor = FetchDescriptor<DayEntry>(sortBy: [SortDescriptor(\.date)])
        let entries = try context.fetch(descriptor)
        
        guard !entries.isEmpty else {
            print("⚠️ No hay entradas para migrar")
            markMigrationComplete()
            return
        }
        
        // 2. Backup automático antes de migrar
        print("💾 Creando backup pre-migración...")
        try await createBackup(entries: entries)
        
        // 3. Migrar valores
        var migratedCount = 0
        
        for entry in entries {
            var changed = false
            
            // Migrar mood (0-10 → 1-5)
            if let oldMood = entry.mood, oldMood > 5 {
                entry.mood = convertToFiveScale(oldMood)
                changed = true
            }
            
            // Migrar energy (0-10 → 1-5)
            if let oldEnergy = entry.energy, oldEnergy > 5 {
                entry.energy = convertToFiveScale(oldEnergy)
                changed = true
            }
            
            // Migrar focus (0-10 → 1-5)
            if let oldFocus = entry.focus, oldFocus > 5 {
                entry.focus = convertToFiveScale(oldFocus)
                changed = true
            }
            
            // Migrar sleep (0-10 → 1-5)
            if let oldSleep = entry.sleep, oldSleep > 5 {
                entry.sleep = convertToFiveScale(oldSleep)
                changed = true
            }
            
            if changed {
                migratedCount += 1
            }
        }
        
        // 4. Guardar cambios
        try context.save()
        
        // 5. Marcar como completada
        markMigrationComplete()
        
        print("✅ Migración completada: \(migratedCount) entradas actualizadas")
    }
    
    /// Convierte un valor de escala 0-10 a 1-5
    /// Fórmula: max(1, round(old / 2.0))
    private static func convertToFiveScale(_ oldValue: Int) -> Int {
        max(1, Int(round(Double(oldValue) / 2.0)))
    }
    
    /// Crea un backup JSON antes de migrar
    private static func createBackup(entries: [DayEntry]) async throws {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let filename = "bitacora-backup-pre-migration-\(timestamp).json"
        
        // Usar el mismo formato de Export
        let payload = entries.map { e in
            [
                "fecha": formatDate(e.date),
                "mood": e.mood as Any,
                "energy": e.energy as Any,
                "focus": e.focus as Any,
                "sleep": e.sleep as Any,
                "notes": e.notes.isEmpty ? nil : e.notes
            ] as [String: Any]
        }
        
        let data = try JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys])
        
        // Guardar en Documents
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        try data.write(to: fileURL)
        
        print("💾 Backup guardado en: \(fileURL.path)")
    }
    
    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    /// Marca la migración como completada
    private static func markMigrationComplete() {
        UserDefaults.standard.set(true, forKey: migrationKey)
        print("✅ Migración marcada como completada")
    }
    
    /// Resetear flag (solo para testing)
    static func resetMigrationFlag() {
        UserDefaults.standard.removeObject(forKey: migrationKey)
    }
}
