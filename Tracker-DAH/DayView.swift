import SwiftUI
import SwiftData

struct DayView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \DayEntry.date) private var entries: [DayEntry]

    @State private var selectedDate = Calendar.current.startOfDay(for: Date())
    @State private var showingCalendar = false
    @State private var showingExport = false
    @State private var showingSettings = false
    @State private var showingAppointments = false
    
    // Estados de expansión de secciones (persistidos)
    @AppStorage("expandedSleep") private var expandedSleep = true
    @AppStorage("expandedFeelings") private var expandedFeelings = true
    @AppStorage("expandedActivities") private var expandedActivities = false
    @AppStorage("expandedGym") private var expandedGym = false
    @AppStorage("expandedHabits") private var expandedHabits = false
    @AppStorage("expandedNotes") private var expandedNotes = false
    
    // Visibilidad de secciones
    @AppStorage("visibleSleep") private var visibleSleep = true
    @AppStorage("visibleFeelings") private var visibleFeelings = true
    @AppStorage("visibleActivities") private var visibleActivities = true
    @AppStorage("visibleGym") private var visibleGym = true
    @AppStorage("visibleHabits") private var visibleHabits = true
    @AppStorage("visibleNotes") private var visibleNotes = true
    
    // Medicación y hábitos
    @AppStorage("showMedication") private var showMedication = true
    @AppStorage("habitFloss") private var habitFloss = true
    @AppStorage("habitAlcohol") private var habitAlcohol = true
    @AppStorage("habitMeditation") private var habitMeditation = true
    @AppStorage("habitReading") private var habitReading = true
    @AppStorage("habitScreens") private var habitScreens = true
    
    // Menú dinámico
    @AppStorage("showAppointmentsInMenu") private var showAppointmentsInMenu = true

    private var calendar: Calendar { Calendar.current }

    // MARK: Acceso al día actual

    private var currentEntry: DayEntry? {
        entries.first { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }

    /// Crea el día en la base de datos solo cuando el usuario escribe algo.
    @discardableResult
    private func ensureEntry() -> DayEntry {
        if let existing = currentEntry { return existing }
        let new = DayEntry(date: selectedDate)
        context.insert(new)
        return new
    }

    /// Binding que crea el día al primer cambio y lee un valor por defecto si aún no existe.
    private func bind<T>(_ keyPath: ReferenceWritableKeyPath<DayEntry, T>, _ fallback: T) -> Binding<T> {
        Binding(
            get: { currentEntry?[keyPath: keyPath] ?? fallback },
            set: { ensureEntry()[keyPath: keyPath] = $0 }
        )
    }

    private func bindOptional<T>(_ keyPath: ReferenceWritableKeyPath<DayEntry, T?>) -> Binding<T?> {
        Binding(
            get: { currentEntry?[keyPath: keyPath] },
            set: { ensureEntry()[keyPath: keyPath] = $0 }
        )
    }

    // MARK: Vista

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    dateNavigator
                    HistoryStrip(
                        days: lastDays(21),
                        selected: selectedDate,
                        moodFor: { day in
                            entries.first { calendar.isDate($0.date, inSameDayAs: day) }?.mood
                        },
                        onSelect: { selectedDate = $0 }
                    )
                    Divider().overlay(Theme.hairline).padding(.vertical, 16)

                    VStack(spacing: 16) {
                        if visibleSleep {
                            CollapsibleSection(
                                title: L10n.sectionSleep,
                                systemImage: "moon.stars.fill",
                                isExpanded: $expandedSleep,
                                badge: badgeForSleep
                            ) {
                                sleepAndMeds
                            }
                        }
                        
                        if visibleFeelings {
                            CollapsibleSection(
                                title: L10n.sectionFeelings,
                                systemImage: "heart.fill",
                                isExpanded: $expandedFeelings,
                                badge: badgeForFeelings
                            ) {
                                feelings
                            }
                        }
                        
                        if visibleActivities {
                            CollapsibleSection(
                                title: L10n.sectionActivities,
                                systemImage: "list.bullet.clipboard.fill",
                                isExpanded: $expandedActivities,
                                badge: badgeForActivities
                            ) {
                                activities
                            }
                        }
                        
                        if visibleGym {
                            CollapsibleSection(
                                title: L10n.sectionGym,
                                systemImage: "figure.run",
                                isExpanded: $expandedGym,
                                badge: badgeForGym
                            ) {
                                gym
                            }
                        }
                        
                        if visibleHabits {
                            CollapsibleSection(
                                title: L10n.sectionHabits,
                                systemImage: "checklist",
                                isExpanded: $expandedHabits,
                                badge: badgeForHabits
                            ) {
                                habits
                            }
                        }
                        
                        if visibleNotes {
                            CollapsibleSection(
                                title: L10n.sectionNotes,
                                systemImage: "doc.text.fill",
                                isExpanded: $expandedNotes,
                                badge: badgeForNotes
                            ) {
                                notes
                            }
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 40)
            }
            .background {
                PaperTextureBackground()
                    .compositingGroup()
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(L10n.tabJournal)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Button {
                            showingExport = true
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .accessibilityLabel(L10n.export)
                        
                        Menu {
                            Button {
                                showingSettings = true
                            } label: {
                                Label(L10n.settings, systemImage: "gearshape")
                            }
                            
                            if showAppointmentsInMenu {
                                Button {
                                    showingAppointments = true
                                } label: {
                                    Label(L10n.appointments, systemImage: "calendar.badge.clock")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                        .accessibilityLabel(L10n.menu)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    if !calendar.isDateInToday(selectedDate) {
                        Button(L10n.today) {
                            withAnimation { selectedDate = calendar.startOfDay(for: Date()) }
                        }
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(L10n.done) { hideKeyboard() }
                }
            }
            .sheet(isPresented: $showingCalendar) { calendarSheet }
            .sheet(isPresented: $showingExport) { ExportView(entries: entries) }
            .sheet(isPresented: $showingSettings) { SettingsView() }
            .sheet(isPresented: $showingAppointments) { AppointmentsView() }
            .onChange(of: selectedDate) { old, _ in
                // Si te vas de un día en el que no apuntaste nada, no lo dejamos guardado.
                cleanUpEmptyEntry(for: old)
            }
        }
    }

    // MARK: Badges (indicadores de progreso)
    
    private var badgeForSleep: String? {
        guard let entry = currentEntry else { return nil }
        var count = 0
        if entry.wakeTime != nil { count += 1 }
        if entry.sleep != nil { count += 1 }
        if showMedication {
            if entry.medTime != nil { count += 1 }
            if !entry.medNotes.isEmpty { count += 1 }
        }
        return count > 0 ? "\(count)" : nil
    }
    
    private var badgeForFeelings: String? {
        guard let entry = currentEntry else { return nil }
        var count = 0
        if entry.mood != nil { count += 1 }
        if entry.energy != nil { count += 1 }
        if entry.focus != nil { count += 1 }
        return count > 0 ? "\(count)/3" : nil
    }
    
    private var badgeForActivities: String? {
        guard let entry = currentEntry else { return nil }
        let count = entry.activities.filter { !$0.isEmpty }.count
        return count > 0 ? "\(count)" : nil
    }
    
    private var badgeForGym: String? {
        guard let entry = currentEntry, entry.didGym else { return nil }
        return "✓"
    }
    
    private var badgeForHabits: String? {
        guard let entry = currentEntry else { return nil }
        var count = 0
        if habitFloss && entry.floss { count += 1 }
        if habitAlcohol && entry.alcohol { count += 1 }
        if habitMeditation && entry.meditated { count += 1 }
        if habitReading && entry.didRead { count += 1 }
        if habitScreens && entry.screensBeforeBed { count += 1 }
        return count > 0 ? "\(count)" : nil
    }
    
    private var badgeForNotes: String? {
        guard let entry = currentEntry,
              !entry.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        return "✓"
    }

    private var sectionDivider: some View {
        Divider().overlay(Theme.hairline).padding(.vertical, 16)
    }

    // MARK: Navegación por fecha

    private var dateNavigator: some View {
        HStack {
            Button {
                shift(by: -1)
            } label: {
                Image(systemName: "chevron.left").navCircle()
            }
            .buttonStyle(.plain)

            Spacer()

            
            Button {
                showingCalendar = true
            } label: {
                VStack(spacing: 2) {

                    Text(
                        selectedDate,
                        format: .dateTime
                            .weekday(.wide)
                            .locale(Locale.current)
                    )
                    .font(.caption)
                    .foregroundStyle(Theme.inkMuted)

                    Text(
                        selectedDate,
                        format: .dateTime
                            .day()
                            .month(.wide)
                            .year()
                            .locale(Locale.current)
                    )
                    .font(.system(.title3, design: Theme.serifFont).weight(.medium))
                    .foregroundStyle(Theme.ink)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                shift(by: 1)
            } label: {
                Image(systemName: "chevron.right").navCircle()
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 4)
    }

    private var calendarSheet: some View {
        NavigationStack {
            DatePicker("Fecha", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .navigationTitle("Ir a un día")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Listo") { showingCalendar = false }
                    }
                }
        }
        .presentationDetents([.medium])
    }

    // MARK: Secciones

    private var sleepAndMeds: some View {
        VStack(alignment: .leading, spacing: 16) {
            optionalTimeRow(label: L10n.wakeTime, keyPath: \.wakeTime)
            RatingPicker(label: L10n.sleepQuality, value: bindOptional(\.sleep))
            
            if showMedication {
                optionalTimeRow(label: L10n.medicationTime, keyPath: \.medTime)

                VStack(alignment: .leading, spacing: 6) {
                    Text(L10n.medicationNotes).font(.subheadline)
                    PlainTextField(placeholder: "media pastilla, no la tomé…", text: bind(\.medNotes, ""))
                }
            }
        }
    }

    private func optionalTimeRow(label: String, keyPath: ReferenceWritableKeyPath<DayEntry, Date?>) -> some View {
        let value = currentEntry?[keyPath: keyPath]
        return HStack {
            Text(label).font(.subheadline)
            Spacer()
            if let value {
                DatePicker(
                    label,
                    selection: Binding(
                        get: { value },
                        set: { ensureEntry()[keyPath: keyPath] = $0 }
                    ),
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                Button {
                    ensureEntry()[keyPath: keyPath] = nil
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.inkMuted)
                }
                .buttonStyle(.plain)
            } else {
                Button(L10n.add) {
                    ensureEntry()[keyPath: keyPath] = Date()
                }
                .font(.subheadline)
            }
        }
    }

    private var activities: some View {
        VStack(alignment: .leading, spacing: 10) {
            let list = currentEntry?.sortedActivities ?? []
            if list.isEmpty {
                Text("Todavía no has añadido nada.")
                    .font(.footnote)
                    .italic()
                    .foregroundStyle(Theme.inkMuted)
            }

            ForEach(list) { item in
                HStack(spacing: 8) {
                    TextField("Hora", text: Bindable(item).time)
                        .frame(width: 70)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 10).padding(.vertical, 9)
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
                        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall).stroke(Theme.hairline, lineWidth: 1))

                    TextField("¿Qué hiciste?", text: Bindable(item).text)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 11).padding(.vertical, 9)
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
                        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall).stroke(Theme.hairline, lineWidth: 1))

                    Button {
                        context.delete(item)
                    } label: {
                        Image(systemName: "minus.circle").foregroundStyle(Theme.inkMuted)
                    }
                    .buttonStyle(.plain)
                }
            }

            Button {
                let entry = ensureEntry()
                let next = (entry.activities.map(\.order).max() ?? -1) + 1
                let item = ActivityItem(order: next)
                item.entry = entry
                context.insert(item)
            } label: {
                Label("Añadir actividad", systemImage: "plus")
                    .font(.subheadline)
            }
            .padding(.top, 2)
        }
    }

    private var gym: some View {
        VStack(alignment: .leading, spacing: 12) {
            ToggleRow(label: L10n.didGym, isOn: bind(\.didGym, false)) {
                PlainTextField(placeholder: "hombro, brazo, correr…", text: bind(\.gymType, ""))
            }
        }
    }

    private var feelings: some View {
        VStack(alignment: .leading, spacing: 18) {
            RatingPicker(label: L10n.mood, value: bindOptional(\.mood))
            RatingPicker(label: L10n.energy, value: bindOptional(\.energy))
            RatingPicker(label: L10n.focus, value: bindOptional(\.focus))
        }
    }

    private var habits: some View {
        VStack(alignment: .leading, spacing: 6) {
            if habitFloss {
                ToggleRow(label: L10n.floss, isOn: bind(\.floss, false))
                if habitAlcohol || habitMeditation || habitReading || habitScreens {
                    Divider().overlay(Theme.hairline)
                }
            }
            
            if habitAlcohol {
                ToggleRow(label: L10n.alcohol, isOn: bind(\.alcohol, false)) {
                    PlainTextField(placeholder: "¿Qué y cuánto?", text: bind(\.alcoholDetail, ""))
                }
                if habitMeditation || habitReading || habitScreens {
                    Divider().overlay(Theme.hairline)
                }
            }
            
            if habitMeditation {
                ToggleRow(label: L10n.meditation, isOn: bind(\.meditated, false)) {
                    MinutesField(placeholder: "Minutos", minutes: bindOptional(\.meditationMinutes))
                }
                if habitReading || habitScreens {
                    Divider().overlay(Theme.hairline)
                }
            }
            
            if habitReading {
                ToggleRow(label: L10n.reading, isOn: bind(\.didRead, false)) {
                    MinutesField(placeholder: "Minutos", minutes: bindOptional(\.readingMinutes))
                }
                if habitScreens {
                    Divider().overlay(Theme.hairline)
                }
            }
            
            if habitScreens {
                ToggleRow(label: L10n.screens, isOn: bind(\.screensBeforeBed, false)) {
                    MinutesField(placeholder: "Minutos", minutes: bindOptional(\.screenMinutes))
                }
            }
            
            // Mensaje si no hay hábitos activados
            if !habitFloss && !habitAlcohol && !habitMeditation && !habitReading && !habitScreens {
                Text("Ve a Configuración para activar hábitos")
                    .font(.footnote)
                    .italic()
                    .foregroundStyle(Theme.inkMuted)
                    .padding(.vertical, 8)
            }
        }
    }

    private var notes: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextEditor(text: bind(\.notes, ""))
                .frame(minHeight: 180)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
                .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
                .overlay(alignment: .topLeading) {
                    if (currentEntry?.notes ?? "").isEmpty {
                        Text("¿Qué ha pasado hoy? ¿Cómo te has sentido y por qué?")
                            .font(.body)
                            .foregroundStyle(Theme.inkMuted)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 16)
                            .allowsHitTesting(false)
                    }
                }
        }
    }

    // MARK: Utilidades

    private func shift(by days: Int) {
        withAnimation(.easeOut(duration: 0.15)) {
            selectedDate = calendar.date(byAdding: .day, value: days, to: selectedDate) ?? selectedDate
        }
    }

    private func lastDays(_ count: Int) -> [Date] {
        let today = calendar.startOfDay(for: Date())
        // Muestra los últimos días hasta hoy, más el día elegido si está en el futuro.
        let end = max(today, selectedDate)
        return (0..<count).compactMap {
            calendar.date(byAdding: .day, value: -(count - 1 - $0), to: end)
        }
    }

    private func cleanUpEmptyEntry(for date: Date) {
        guard let stale = entries.first(where: { calendar.isDate($0.date, inSameDayAs: date) }),
              stale.isEmpty else { return }
        context.delete(stale)
    }

    private func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}

private extension Image {
    func navCircle() -> some View {
        self.font(.body.weight(.light))
            .foregroundStyle(Theme.ink)
            .frame(width: 36, height: 36)
            .background(Theme.card, in: Circle())
            .overlay(Circle().stroke(Theme.hairline, lineWidth: 1))
    }
}
