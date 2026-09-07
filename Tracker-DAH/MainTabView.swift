import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            DayView()
                .tabItem {
                    Label(L10n.tabJournal, systemImage: "book.fill")
                }
            
            WeeklySummaryView()
                .tabItem {
                    Label(L10n.tabSummary, systemImage: "calendar")
                }
            
            ChartsView()
                .tabItem {
                    Label(L10n.tabCharts, systemImage: "chart.line.uptrend.xyaxis")
                }
        }
        .tint(Theme.accent)
    }
}

// MARK: - Vista de resumen semanal

struct WeeklySummaryView: View {
    @Query(sort: \DayEntry.date, order: .reverse) private var entries: [DayEntry]
    @State private var selectedWeek = 0
    
    private var calendar: Calendar { Calendar.current }
    
    private var weeks: [[DayEntry]] {
        let grouped = Dictionary(grouping: entries) { entry in
            calendar.component(.weekOfYear, from: entry.date)
        }
        return grouped.values.sorted { $0.first!.date > $1.first!.date }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if weeks.isEmpty {
                        ContentUnavailableView(
                            L10n.noDataYet,
                            systemImage: "calendar.badge.clock",
                            description: Text(L10n.startFilling)
                        )
                    } else {
                        ForEach(Array(weeks.enumerated()), id: \.offset) { index, week in
                            WeekCard(days: week.sorted { $0.date < $1.date })
                        }
                    }
                }
                .padding()
            }
            .background {
                PaperTextureBackground()
                    .compositingGroup()
            }
            .navigationTitle(L10n.weeklySummary)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct WeekCard: View {
    let days: [DayEntry]
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var calendar: Calendar { Calendar.current }
    
    private var weekRange: String {
        guard let first = days.first?.date, let last = days.last?.date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d MMM"
        return "\(formatter.string(from: first)) - \(formatter.string(from: last))"
    }
    
    private var averageMood: Double? {
        let moods = days.compactMap { $0.mood }
        guard !moods.isEmpty else { return nil }
        return Double(moods.reduce(0, +)) / Double(moods.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(weekRange)
                    .font(.system(.title3, design: Theme.serifFont).weight(.medium))
                    .foregroundStyle(Theme.ink)
                
                Spacer()
                
                if let avg = averageMood {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.circle")
                            .font(.caption.weight(.light))
                            .foregroundStyle(Theme.accent)
                        Text(String(format: "%.1f", avg))
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Theme.ink)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Theme.accent.opacity(0.08), in: Capsule())
                }
            }
            
            // Mini calendario de la semana
            HStack(spacing: 8) {
                ForEach(days, id: \.date) { day in
                    VStack(spacing: 4) {
                        Text(day.date, format: .dateTime.weekday(.abbreviated).locale(Locale.current))
                            .font(.caption2)
                            .foregroundStyle(Theme.inkMuted)
                        
                        Circle()
                            .fill(Theme.shade(for: day.mood, colorScheme: colorScheme))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text(day.date, format: .dateTime.day())
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(day.mood != nil ? Theme.paperBackground : Theme.inkMuted)
                            )
                    }
                }
            }
            
            Divider().overlay(Theme.hairline)
            
            // Notas de la semana
            ForEach(days.filter { !$0.notes.isEmpty }, id: \.date) { day in
                VStack(alignment: .leading, spacing: 4) {
                    Text(day.date, format: .dateTime.day().month(.abbreviated).locale(Locale.current))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                    
                    Text(day.notes)
                        .font(.subheadline)
                        .foregroundStyle(Theme.ink)
                        .lineLimit(3)
                }
                .padding(.vertical, 4)
            }
            
            if days.allSatisfy({ $0.notes.isEmpty }) {
                Text(L10n.noNotesWeek)
                    .font(.footnote)
                    .italic()
                    .foregroundStyle(Theme.inkMuted)
            }
        }
        .padding(16)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
    }
}

// MARK: - Vista de gráficas y estadísticas

struct ChartsView: View {
    @Query(sort: \DayEntry.date, order: .reverse) private var entries: [DayEntry]
    @State private var selectedMetric: Metric = .mood
    @State private var timeRange: TimeRange = .week
    
    enum Metric: String, CaseIterable {
        case mood, sleep, energy, focus
        
        var localizedName: String {
            switch self {
            case .mood: return L10n.mood
            case .sleep: return L10n.sleep
            case .energy: return L10n.energy
            case .focus: return L10n.focus
            }
        }
    }
    
    enum TimeRange: String, CaseIterable {
        case week = "7 días"
        case twoWeeks = "14 días"
        case month = "30 días"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .twoWeeks: return 14
            case .month: return 30
            }
        }
    }
    
    private var filteredEntries: [DayEntry] {
        let cal = Calendar.current
        let cutoff = cal.date(byAdding: .day, value: -timeRange.days, to: Date()) ?? Date()
        return entries.filter { $0.date >= cutoff }.reversed()
    }
    
    private func value(for entry: DayEntry, metric: Metric) -> Int? {
        switch metric {
        case .mood: return entry.mood
        case .sleep: return entry.sleep
        case .energy: return entry.energy
        case .focus: return entry.focus
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Selectores
                    VStack(spacing: 12) {
                        Picker("Métrica", selection: $selectedMetric) {
                            ForEach(Metric.allCases, id: \.self) { metric in
                                Text(metric.localizedName).tag(metric)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Picker("Período", selection: $timeRange) {
                            ForEach(TimeRange.allCases, id: \.self) { range in
                                Text(range.rawValue).tag(range)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal)
                    
                    // Gráfica simple
                    SimpleLineChart(
                        entries: filteredEntries,
                        metric: selectedMetric,
                        getValue: value
                    )
                    .frame(height: 220)
                    .padding(.horizontal)
                    
                    // Estadísticas
                    StatsGrid(entries: filteredEntries, metric: selectedMetric, getValue: value)
                        .padding(.horizontal)
                    
                    // Rachas de hábitos
                    HabitsStreaksView(entries: entries)
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background {
                PaperTextureBackground()
                    .compositingGroup()
            }
            .navigationTitle(L10n.analysis)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Gráfica simple de línea

struct SimpleLineChart: View {
    let entries: [DayEntry]
    let metric: ChartsView.Metric
    let getValue: (DayEntry, ChartsView.Metric) -> Int?
    
    private var points: [(date: Date, value: Double)] {
        entries.compactMap { entry in
            guard let val = getValue(entry, metric) else { return nil }
            return (entry.date, Double(val))
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(metric.localizedName)
                .font(.system(.title3, design: Theme.serifFont))
                .foregroundStyle(Theme.ink)
            
            if points.isEmpty {
                ContentUnavailableView(
                    "Sin datos",
                    systemImage: "chart.line.downtrend.xyaxis",
                    description: Text("Empieza a puntuar tu \(metric.localizedName.lowercased())")
                )
            } else {
                GeometryReader { geo in
                    ZStack(alignment: .bottomLeading) {
                        // Líneas de fondo (papel rayado estilo cuaderno)
                        ForEach(0..<6) { i in
                            Path { path in
                                let y = geo.size.height * (1 - CGFloat(i) / 5)
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: geo.size.width, y: y))
                            }
                            .stroke(Theme.hairline, style: StrokeStyle(lineWidth: 0.5, dash: [2, 4]))
                        }
                        
                        // Línea de datos (fina y cálida)
                        Path { path in
                            for (index, point) in points.enumerated() {
                                let x = CGFloat(index) / CGFloat(max(points.count - 1, 1)) * geo.size.width
                                // Escala 1-5: normalizar a 0-1 para el eje Y
                                let y = geo.size.height * (1 - (point.value - 1) / 4)
                                
                                if index == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                } else {
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }
                        }
                        .stroke(Theme.accent, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                        
                        // Puntos (pequeños con contorno, no rellenos)
                        ForEach(Array(points.enumerated()), id: \.offset) { index, point in
                            let x = CGFloat(index) / CGFloat(max(points.count - 1, 1)) * geo.size.width
                            // Escala 1-5: normalizar a 0-1 para el eje Y
                            let y = geo.size.height * (1 - (point.value - 1) / 4)
                            
                            Circle()
                                .strokeBorder(Theme.accent, lineWidth: 1.5)
                                .background(Circle().fill(Theme.paperBackground))
                                .frame(width: 6, height: 6)
                                .position(x: x, y: y)
                        }
                    }
                }
                .padding(.vertical, 10)
            }
        }
        .padding(16)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
    }
}

// MARK: - Grid de estadísticas

struct StatsGrid: View {
    let entries: [DayEntry]
    let metric: ChartsView.Metric
    let getValue: (DayEntry, ChartsView.Metric) -> Int?
    
    private var values: [Int] {
        entries.compactMap { getValue($0, metric) }
    }
    
    private var average: Double? {
        guard !values.isEmpty else { return nil }
        return Double(values.reduce(0, +)) / Double(values.count)
    }
    
    private var highest: Int? { values.max() }
    private var lowest: Int? { values.min() }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.statistics)
                .font(.system(.headline, design: .serif))
                .foregroundStyle(Theme.ink)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(title: L10n.average, value: average.map { String(format: "%.1f", $0) } ?? "—", icon: "chart.bar.fill")
                StatCard(title: L10n.maximum, value: highest.map(String.init) ?? "—", icon: "arrow.up.circle.fill")
                StatCard(title: L10n.minimum, value: lowest.map(String.init) ?? "—", icon: "arrow.down.circle.fill")
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3.weight(.light))
                .foregroundStyle(Theme.accent)
            
            Text(value)
                .font(.system(.title, design: Theme.serifFont).weight(.medium))
                .foregroundStyle(Theme.ink)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.inkMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
    }
}

// MARK: - Vista de rachas de hábitos

struct HabitsStreaksView: View {
    let entries: [DayEntry]
    
    private struct Habit {
        let name: String
        let keyPath: KeyPath<DayEntry, Bool>
        let icon: String
    }
    
    private let habits = [
        Habit(name: L10n.floss, keyPath: \DayEntry.floss, icon: "mouth"),
        Habit(name: "Gimnasio", keyPath: \DayEntry.didGym, icon: "figure.run"),
        Habit(name: L10n.meditation, keyPath: \DayEntry.meditated, icon: "leaf.fill"),
        Habit(name: L10n.reading, keyPath: \DayEntry.didRead, icon: "book.fill")
    ]
    
    private func streak(for habit: Habit) -> Int {
        let sorted = entries.sorted { $0.date > $1.date }
        var count = 0
        
        for entry in sorted {
            if entry[keyPath: habit.keyPath] {
                count += 1
            } else {
                break
            }
        }
        
        return count
    }
    
    private func totalDays(for habit: Habit) -> Int {
        entries.filter { $0[keyPath: habit.keyPath] }.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.habitStreaks)
                .font(.system(.headline, design: .serif))
                .foregroundStyle(Theme.ink)
            
            VStack(spacing: 8) {
                ForEach(habits, id: \.name) { habit in
                    HabitStreakRow(
                        icon: habit.icon,
                        name: habit.name,
                        currentStreak: streak(for: habit),
                        totalDays: totalDays(for: habit)
                    )
                }
            }
        }
    }
}

struct HabitStreakRow: View {
    let icon: String
    let name: String
    let currentStreak: Int
    let totalDays: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // Icono sketch con círculo punteado
            ZStack {
                Circle()
                    .strokeBorder(Theme.hairline, style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.body.weight(.light))
                    .foregroundStyle(Theme.accent)
            }
            
            Text(name)
                .font(.subheadline)
                .foregroundStyle(Theme.ink)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 4) {
                    Image(systemName: currentStreak > 0 ? "flame.circle" : "flame.circle.fill")
                        .font(.caption.weight(.light))
                        .foregroundStyle(currentStreak > 0 ? Theme.accent : Theme.inkMuted)
                    Text("\(currentStreak) días")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.ink)
                }
                
                Text("\(totalDays) total")
                    .font(.caption)
                    .foregroundStyle(Theme.inkMuted)
            }
        }
        .padding(12)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [DayEntry.self, ActivityItem.self, RecurringAppointment.self], inMemory: true)
}
