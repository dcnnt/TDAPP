import SwiftUI
import SwiftData
import UniformTypeIdentifiers

// MARK: - Pantalla de exportación

struct ExportView: View {
    let entries: [DayEntry]
    @Environment(\.dismiss) private var dismiss
    @State private var csvURL: URL?
    @State private var jsonURL: URL?
    @State private var errorMessage: String?

    private var dayCount: Int { entries.filter { !$0.isEmpty }.count }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(dayCount == 0
                         ? "Todavía no hay días apuntados."
                         : "Tienes \(dayCount) \(dayCount == 1 ? "día apuntado" : "días apuntados").")
                        .font(.subheadline)
                        .foregroundStyle(Theme.inkMuted)

                    if let csvURL {
                        ShareLink(item: csvURL) {
                            exportRow(
                                title: "CSV",
                                detail: "Una fila por día. Para abrirlo en Excel o Google Sheets.",
                                icon: "tablecells"
                            )
                        }
                    }

                    if let jsonURL {
                        ShareLink(item: jsonURL) {
                            exportRow(
                                title: "JSON",
                                detail: "Con todo el detalle. Para pegárselo a una IA y que analice patrones.",
                                icon: "curlybraces"
                            )
                        }
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }

                    Spacer(minLength: 40)
                }
                .padding(20)
            }
            .background {
                PaperTextureBackground()
                    .compositingGroup()
            }
            .navigationTitle("Exportar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
            .task { prepareFiles() }
        }
        .presentationDetents([.medium])
    }

    private func exportRow(title: String, detail: String, icon: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3.weight(.light))
                .foregroundStyle(Theme.accent)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(.headline, design: .serif))
                    .foregroundStyle(Theme.ink)
                Text(detail)
                    .font(.footnote)
                    .foregroundStyle(Theme.inkMuted)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            Image(systemName: "square.and.arrow.up")
                .font(.body.weight(.light))
                .foregroundStyle(Theme.inkMuted)
        }
        .padding(14)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
    }

    private func prepareFiles() {
        let sorted = entries.filter { !$0.isEmpty }.sorted { $0.date < $1.date }
        do {
            csvURL = try Exporter.writeCSV(sorted)
            jsonURL = try Exporter.writeJSON(sorted)
        } catch {
            errorMessage = "No se pudieron preparar los archivos. Inténtalo otra vez."
        }
    }
}

// MARK: - Generación de archivos

enum Exporter {

    private static var stamp: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    // MARK: CSV

    static func writeCSV(_ entries: [DayEntry]) throws -> URL {
        let headers = [
            "fecha", "despertar", "hora_medicacion", "notas_medicacion",
            "sueno", "animo", "energia", "foco",
            "gym", "tipo_gym", "hilo_dental",
            "alcohol", "detalle_alcohol",
            "meditacion", "min_meditacion",
            "lectura", "min_lectura",
            "pantallas_antes_dormir", "min_pantallas",
            "actividades", "notas"
        ]

        var rows = [headers.joined(separator: ",")]

        for e in entries {
            let acts = e.sortedActivities
                .filter { !$0.isEmpty }
                .map { $0.time.isEmpty ? $0.text : "\($0.time): \($0.text)" }
                .joined(separator: " | ")

            let fields: [String] = [
                dayFormatter.string(from: e.date),
                e.wakeTime.map { timeFormatter.string(from: $0) } ?? "",
                e.medTime.map { timeFormatter.string(from: $0) } ?? "",
                e.medNotes,
                e.sleep.map(String.init) ?? "",
                e.mood.map(String.init) ?? "",
                e.energy.map(String.init) ?? "",
                e.focus.map(String.init) ?? "",
                e.didGym ? "sí" : "no",
                e.gymType,
                e.floss ? "sí" : "no",
                e.alcohol ? "sí" : "no",
                e.alcoholDetail,
                e.meditated ? "sí" : "no",
                e.meditationMinutes.map(String.init) ?? "",
                e.didRead ? "sí" : "no",
                e.readingMinutes.map(String.init) ?? "",
                e.screensBeforeBed ? "sí" : "no",
                e.screenMinutes.map(String.init) ?? "",
                acts,
                e.notes
            ]
            rows.append(fields.map(escape).joined(separator: ","))
        }

        // BOM para que Excel respete los acentos
        let content = "\u{FEFF}" + rows.joined(separator: "\r\n")
        return try write(content, filename: "bitacora-\(stamp).csv")
    }

    private static func escape(_ value: String) -> String {
        guard value.contains(where: { $0 == "," || $0 == "\"" || $0 == "\n" || $0 == "\r" }) else {
            return value
        }
        return "\"" + value.replacingOccurrences(of: "\"", with: "\"\"") + "\""
    }

    // MARK: JSON

    struct ExportMetadata: Encodable {
        let version: Int
        let scale: String
        let exportDate: String
        let totalEntries: Int
        let entries: [DayExport]
    }

    struct DayExport: Encodable {
        let fecha: String
        let despertar: String?
        let horaMedicacion: String?
        let notasMedicacion: String?
        let sueno: Int?
        let animo: Int?
        let energia: Int?
        let foco: Int?
        let gym: Bool
        let tipoGym: String?
        let hiloDental: Bool
        let alcohol: Bool
        let detalleAlcohol: String?
        let meditacionMinutos: Int?
        let lecturaMinutos: Int?
        let pantallasMinutos: Int?
        let actividades: [String]
        let notas: String?
    }

    static func writeJSON(_ entries: [DayEntry]) throws -> URL {
        let dayExports = entries.map { e in
            DayExport(
                fecha: dayFormatter.string(from: e.date),
                despertar: e.wakeTime.map { timeFormatter.string(from: $0) },
                horaMedicacion: e.medTime.map { timeFormatter.string(from: $0) },
                notasMedicacion: e.medNotes.isEmpty ? nil : e.medNotes,
                sueno: e.sleep,
                animo: e.mood,
                energia: e.energy,
                foco: e.focus,
                gym: e.didGym,
                tipoGym: e.gymType.isEmpty ? nil : e.gymType,
                hiloDental: e.floss,
                alcohol: e.alcohol,
                detalleAlcohol: e.alcoholDetail.isEmpty ? nil : e.alcoholDetail,
                meditacionMinutos: e.meditated ? e.meditationMinutes : nil,
                lecturaMinutos: e.didRead ? e.readingMinutes : nil,
                pantallasMinutos: e.screensBeforeBed ? e.screenMinutes : nil,
                actividades: e.sortedActivities.filter { !$0.isEmpty }.map {
                    $0.time.isEmpty ? $0.text : "\($0.time): \($0.text)"
                },
                notas: e.notes.isEmpty ? nil : e.notes
            )
        }
        
        let metadata = ExportMetadata(
            version: 2,
            scale: "1-5",
            exportDate: stamp,
            totalEntries: entries.count,
            entries: dayExports
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        let data = try encoder.encode(metadata)
        let content = String(decoding: data, as: UTF8.self)
        return try write(content, filename: "bitacora-\(stamp).json")
    }

    // MARK: Escritura a disco

    private static func write(_ content: String, filename: String) throws -> URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try content.write(to: url, atomically: true, encoding: .utf8)
        return url
    }
}
