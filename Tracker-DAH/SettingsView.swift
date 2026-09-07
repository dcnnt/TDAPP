import SwiftUI
import UserNotifications

// MARK: - Vista de configuración

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("customHabits") private var customHabitsData: Data = Data()
    
    @State private var customHabits: [CustomHabit] = []
    @State private var showingAddHabit = false
    @State private var newHabitName = ""
    @State private var newHabitIcon = "star.fill"
    @State private var showingAdvanced = false
    @State private var notificationStatus: UNAuthorizationStatus = .notDetermined
    @State private var appliedPreset: PresetType? = nil
    
    enum PresetType {
        case minimalist, complete, noMedication
    }
    
    private let availableIcons = [
        "star.fill", "heart.fill", "leaf.fill", "drop.fill",
        "flame.fill", "bolt.fill", "moon.fill", "sun.max.fill",
        "figure.walk", "figure.yoga", "figure.mind.and.body",
        "book.fill", "pencil", "paintbrush.fill", "music.note",
        "fork.knife", "cup.and.saucer.fill", "water.waves",
        "pills.fill", "cross.vial", "bandage.fill"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // MARK: Presets
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeading(title: L10n.settingsPresets)
                        
                        Text(L10n.settingsPresetsDescription)
                            .font(.footnote)
                            .foregroundStyle(Theme.inkMuted)
                            .padding(.bottom, 4)
                        
                        VStack(spacing: 8) {
                            presetButton(
                                title: L10n.settingsPresetMinimalist,
                                description: L10n.settingsPresetMinimalistDescription,
                                icon: "rectangle.compress.vertical",
                                preset: .minimalist,
                                action: applyMinimalistPreset
                            )
                            
                            presetButton(
                                title: L10n.settingsPresetComplete,
                                description: L10n.settingsPresetCompleteDescription,
                                icon: "rectangle.expand.vertical",
                                preset: .complete,
                                action: applyCompletePreset
                            )
                            
                            presetButton(
                                title: L10n.settingsPresetNoMedication,
                                description: L10n.settingsPresetNoMedicationDescription,
                                icon: "cross.vial",
                                preset: .noMedication,
                                action: applyNoMedicationPreset
                            )
                        }
                    }
                    
                    // MARK: Secciones con tres estados
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeading(title: L10n.settingsSections)
                        
                        Text(L10n.settingsSectionsDescription)
                            .font(.footnote)
                            .foregroundStyle(Theme.inkMuted)
                            .padding(.bottom, 4)
                        
                        VStack(spacing: 8) {
                            SectionStateRow(
                                icon: "bed.double.fill",
                                title: L10n.sectionSleep,
                                state: sectionState(for: "Sleep")
                            ) { newState in
                                setSectionState("Sleep", to: newState)
                            }
                            
                            SectionStateRow(
                                icon: "face.smiling",
                                title: L10n.sectionFeelings,
                                state: sectionState(for: "Feelings")
                            ) { newState in
                                setSectionState("Feelings", to: newState)
                            }
                            
                            SectionStateRow(
                                icon: "list.bullet",
                                title: L10n.sectionActivities,
                                state: sectionState(for: "Activities")
                            ) { newState in
                                setSectionState("Activities", to: newState)
                            }
                            
                            SectionStateRow(
                                icon: "figure.run",
                                title: L10n.sectionGym,
                                state: sectionState(for: "Gym")
                            ) { newState in
                                setSectionState("Gym", to: newState)
                            }
                            
                            SectionStateRow(
                                icon: "checkmark.circle",
                                title: L10n.sectionHabits,
                                state: sectionState(for: "Habits")
                            ) { newState in
                                setSectionState("Habits", to: newState)
                            }
                            
                            SectionStateRow(
                                icon: "note.text",
                                title: L10n.sectionNotes,
                                state: sectionState(for: "Notes")
                            ) { newState in
                                setSectionState("Notes", to: newState)
                            }
                        }
                    }
                    
                    // MARK: Opciones avanzadas (colapsado)
                    DisclosureGroup(
                        isExpanded: $showingAdvanced
                    ) {
                        advancedOptionsContent
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "gearshape.2")
                                .font(.body.weight(.light))
                                .foregroundStyle(Theme.accent)
                                .frame(width: 24)
                            
                            Text(L10n.settingsAdvanced)
                                .font(.system(.headline, design: .serif))
                                .foregroundStyle(Theme.ink)
                        }
                    }
                    .tint(Theme.accent)
                    .padding(16)
                    .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
                    .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
                    
                    // MARK: Footer
                    Text(L10n.settingsVersion)
                        .font(.caption)
                        .foregroundStyle(Theme.inkMuted)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
                }
                .padding(20)
            }
            .background {
                PaperTextureBackground()
                    .compositingGroup()
            }
            .navigationTitle(L10n.settings)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.done) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                addHabitSheet
            }
            .onAppear {
                loadCustomHabits()
                checkNotificationStatus()
            }
        }
    }
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationStatus = settings.authorizationStatus
            }
        }
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Advanced Options Content
    
    private var advancedOptionsContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            medicationSection
            Divider().overlay(Theme.hairline)
            notificationsSection
            Divider().overlay(Theme.hairline)
            defaultHabitsSection
            Divider().overlay(Theme.hairline)
            customHabitsSection
            Divider().overlay(Theme.hairline)
            menuOptionsSection
            Divider().overlay(Theme.hairline)
            resetSection
        }
    }
    
    private var medicationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.settingsMedication)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Theme.ink)
            
            Toggle(L10n.showMedication, isOn: binding(for: "showMedication", default: true))
                .padding(12)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
                .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
            
            Text(L10n.includeMedicationFields)
                .font(.caption)
                .foregroundStyle(Theme.inkMuted)
        }
        .padding(.top, 8)
    }
    
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.notificationsTitle)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Theme.ink)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.notificationsStatus)
                        .font(.caption)
                        .foregroundStyle(Theme.inkMuted)
                    
                    Text(notificationStatus == .authorized ? L10n.notificationsEnabled : L10n.notificationsDisabled)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(notificationStatus == .authorized ? .green : .orange)
                }
                
                Spacer()
                
                if notificationStatus != .authorized {
                    Button {
                        openSettings()
                    } label: {
                        Text(L10n.notificationsOpenSettings)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Theme.accent)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accent.opacity(0.12), in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(12)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
            
            Text(L10n.notificationsDescription)
                .font(.caption)
                .foregroundStyle(Theme.inkMuted)
        }
    }
    
    private var defaultHabitsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.defaultHabits)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Theme.ink)
            
            VStack(spacing: 6) {
                habitToggle(L10n.floss, key: "habitFloss")
                habitToggle(L10n.alcohol, key: "habitAlcohol")
                habitToggle(L10n.meditation, key: "habitMeditation")
                habitToggle(L10n.reading, key: "habitReading")
                habitToggle(L10n.screens, key: "habitScreens")
            }
            
            Text(L10n.enableDisableHabits)
                .font(.caption)
                .foregroundStyle(Theme.inkMuted)
        }
    }
    
    private func habitToggle(_ label: String, key: String) -> some View {
        Toggle(label, isOn: binding(for: key, default: true))
            .padding(10)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall).stroke(Theme.hairline, lineWidth: 1))
    }
    
    private var customHabitsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.settingsCustomHabits)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Theme.ink)
            
            if !customHabits.isEmpty {
                VStack(spacing: 6) {
                    ForEach(customHabits) { habit in
                        HStack {
                            Image(systemName: habit.icon)
                                .foregroundStyle(Theme.accent)
                                .frame(width: 24)
                            Text(habit.name)
                                .font(.subheadline)
                                .foregroundStyle(Theme.ink)
                            Spacer()
                        }
                        .padding(10)
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
                        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall).stroke(Theme.hairline, lineWidth: 1))
                    }
                }
            }
            
            Button {
                showingAddHabit = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(Theme.accent)
                    Text(L10n.settingsAddCustomHabit)
                        .font(.subheadline)
                        .foregroundStyle(Theme.ink)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
                .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall).stroke(Theme.accent.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [3, 3])))
            }
            .buttonStyle(.plain)
            
            Text(L10n.settingsCustomHabitsDescription)
                .font(.caption)
                .foregroundStyle(Theme.inkMuted)
        }
    }
    
    private var menuOptionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.menuOptions)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Theme.ink)
            
            Toggle(L10n.showAppointmentsInMenu, isOn: binding(for: "showAppointmentsInMenu", default: true))
                .padding(12)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
                .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
            
            Text(L10n.menuOptionsDescription)
                .font(.caption)
                .foregroundStyle(Theme.inkMuted)
        }
    }
    
    private var resetSection: some View {
        Button {
            resetDefaults()
        } label: {
            HStack {
                Image(systemName: "arrow.counterclockwise")
                Text(L10n.resetPreferences)
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(Color.red.opacity(0.08), in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Color.red.opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .padding(.bottom, 8)
    }
    
    private var addHabitSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L10n.settingsHabitName)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Theme.ink)
                        
                        TextField(L10n.settingsHabitNamePlaceholder, text: $newHabitName)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.horizontal, 11)
                            .padding(.vertical, 9)
                            .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
                            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall).stroke(Theme.hairline, lineWidth: 1))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L10n.settingsHabitIcon)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Theme.ink)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
                            ForEach(availableIcons, id: \.self) { icon in
                                Button {
                                    newHabitIcon = icon
                                } label: {
                                    Image(systemName: icon)
                                        .font(.title3)
                                        .foregroundStyle(newHabitIcon == icon ? .white : Theme.accent)
                                        .frame(width: 50, height: 50)
                                        .background(newHabitIcon == icon ? Theme.accent : Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
                                        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall).stroke(newHabitIcon == icon ? Theme.accent : Theme.hairline, lineWidth: 1.5))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    Button {
                        addCustomHabit()
                    } label: {
                        Text(L10n.settingsSaveHabit)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(Theme.accent, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
                    }
                    .buttonStyle(.plain)
                    .disabled(newHabitName.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(newHabitName.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
                }
                .padding(20)
            }
            .background {
                PaperTextureBackground()
                    .compositingGroup()
            }
            .navigationTitle(L10n.settingsNewHabit)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.cancel) {
                        showingAddHabit = false
                        newHabitName = ""
                        newHabitIcon = "star.fill"
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    // MARK: - Section State
    
    enum SectionState: Hashable {
        case hidden, collapsed, expanded
    }
    
    private func sectionState(for section: String) -> SectionState {
        let visible = UserDefaults.standard.object(forKey: "visible\(section)") as? Bool ?? true
        if !visible { return .hidden }
        let expanded = UserDefaults.standard.object(forKey: "expanded\(section)") as? Bool ?? false
        return expanded ? .expanded : .collapsed
    }
    
    private func setSectionState(_ section: String, to state: SectionState) {
        switch state {
        case .hidden:
            UserDefaults.standard.set(false, forKey: "visible\(section)")
            UserDefaults.standard.set(false, forKey: "expanded\(section)")
        case .collapsed:
            UserDefaults.standard.set(true, forKey: "visible\(section)")
            UserDefaults.standard.set(false, forKey: "expanded\(section)")
        case .expanded:
            UserDefaults.standard.set(true, forKey: "visible\(section)")
            UserDefaults.standard.set(true, forKey: "expanded\(section)")
        }
    }
    
    // MARK: - Presets
    
    private func applyMinimalistPreset() {
        // Solo Sueño y Sentimientos abiertos
        setSectionState("Sleep", to: .expanded)
        setSectionState("Feelings", to: .expanded)
        setSectionState("Activities", to: .hidden)
        setSectionState("Gym", to: .hidden)
        setSectionState("Habits", to: .hidden)
        setSectionState("Notes", to: .collapsed)
        
        // Medicación activada
        UserDefaults.standard.set(true, forKey: "showMedication")
        
        // Hábitos: solo esenciales
        UserDefaults.standard.set(false, forKey: "habitFloss")
        UserDefaults.standard.set(false, forKey: "habitAlcohol")
        UserDefaults.standard.set(true, forKey: "habitMeditation")
        UserDefaults.standard.set(false, forKey: "habitReading")
        UserDefaults.standard.set(true, forKey: "habitScreens")
    }
    
    private func applyCompletePreset() {
        // Todo visible y abierto
        setSectionState("Sleep", to: .expanded)
        setSectionState("Feelings", to: .expanded)
        setSectionState("Activities", to: .expanded)
        setSectionState("Gym", to: .expanded)
        setSectionState("Habits", to: .expanded)
        setSectionState("Notes", to: .expanded)
        
        // Todo activado
        UserDefaults.standard.set(true, forKey: "showMedication")
        UserDefaults.standard.set(true, forKey: "habitFloss")
        UserDefaults.standard.set(true, forKey: "habitAlcohol")
        UserDefaults.standard.set(true, forKey: "habitMeditation")
        UserDefaults.standard.set(true, forKey: "habitReading")
        UserDefaults.standard.set(true, forKey: "habitScreens")
    }
    
    private func applyNoMedicationPreset() {
        // Secciones principales cerradas, sin medicación
        setSectionState("Sleep", to: .collapsed)
        setSectionState("Feelings", to: .expanded)
        setSectionState("Activities", to: .collapsed)
        setSectionState("Gym", to: .collapsed)
        setSectionState("Habits", to: .collapsed)
        setSectionState("Notes", to: .collapsed)
        
        // Sin medicación
        UserDefaults.standard.set(false, forKey: "showMedication")
        
        // Hábitos básicos
        UserDefaults.standard.set(true, forKey: "habitFloss")
        UserDefaults.standard.set(false, forKey: "habitAlcohol")
        UserDefaults.standard.set(true, forKey: "habitMeditation")
        UserDefaults.standard.set(true, forKey: "habitReading")
        UserDefaults.standard.set(false, forKey: "habitScreens")
    }
    
    // MARK: - Helpers
    
    private func binding(for key: String, default defaultValue: Bool) -> Binding<Bool> {
        Binding(
            get: { UserDefaults.standard.object(forKey: key) as? Bool ?? defaultValue },
            set: { UserDefaults.standard.set($0, forKey: key) }
        )
    }
    
    private func resetDefaults() {
        // Definir todas las claves que se deben resetear
        let sectionStates = ["Sleep", "Feelings", "Activities", "Gym", "Habits", "Notes"]
        let sectionKeys = sectionStates.flatMap { ["expanded\($0)", "visible\($0)"] }
        let habitKeys = ["habitFloss", "habitAlcohol", "habitMeditation", "habitReading", "habitScreens"]
        let otherKeys = ["showMedication", "showAppointmentsInMenu"]
        
        let allKeys = sectionKeys + habitKeys + otherKeys
        allKeys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
        
        customHabits = []
        customHabitsData = Data()
    }
    
    private func loadCustomHabits() {
        guard let decoded = try? JSONDecoder().decode([CustomHabit].self, from: customHabitsData) else {
            customHabits = []
            return
        }
        customHabits = decoded
    }
    
    private func saveCustomHabits() {
        guard let encoded = try? JSONEncoder().encode(customHabits) else { return }
        customHabitsData = encoded
    }
    
    private func addCustomHabit() {
        let habit = CustomHabit(name: newHabitName.trimmingCharacters(in: .whitespaces), icon: newHabitIcon)
        customHabits.append(habit)
        saveCustomHabits()
        showingAddHabit = false
        newHabitName = ""
        newHabitIcon = "star.fill"
    }
    
    // MARK: - Helper Views
    
    private func presetButton(
        title: String,
        description: String,
        icon: String,
        preset: PresetType,
        action: @escaping () -> Void
    ) -> some View {
        PresetButton(
            title: title,
            description: description,
            icon: icon,
            isApplied: appliedPreset == preset
        ) {
            withAnimation(.easeOut(duration: 0.2)) {
                action()
                appliedPreset = preset
            }
            Task {
                try? await Task.sleep(for: .seconds(2))
                await MainActor.run {
                    withAnimation {
                        appliedPreset = nil
                    }
                }
            }
        }
    }
}

// MARK: - Componentes auxiliares

struct PresetButton: View {
    let title: String
    let description: String
    let icon: String
    let isApplied: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3.weight(.light))
                    .foregroundStyle(isApplied ? .white : Theme.accent)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(isApplied ? .white : Theme.ink)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(isApplied ? .white.opacity(0.8) : Theme.inkMuted)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if isApplied {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.body)
                        .foregroundStyle(.white)
                } else {
                    Image(systemName: "arrow.right.circle")
                        .font(.body)
                        .foregroundStyle(Theme.inkMuted)
                }
            }
            .padding(14)
            .background(isApplied ? Theme.accent : Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(isApplied ? Theme.accent : Theme.hairline, lineWidth: isApplied ? 2 : 1))
        }
        .buttonStyle(.plain)
    }
}

struct SectionStateRow: View {
    let icon: String
    let title: String
    let state: SettingsView.SectionState
    let onChange: (SettingsView.SectionState) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.body.weight(.light))
                    .foregroundStyle(Theme.accent)
                    .frame(width: 24)
                
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.ink)
            }
            
            Picker(title, selection: Binding(
                get: { state },
                set: { newValue in
                    onChange(newValue)
                }
            )) {
                Text(L10n.settingsStateHidden).tag(SettingsView.SectionState.hidden)
                Text(L10n.settingsStateCollapsed).tag(SettingsView.SectionState.collapsed)
                Text(L10n.settingsStateExpanded).tag(SettingsView.SectionState.expanded)
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
        .padding(12)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
    }
}

// MARK: - Modelo de hábito personalizado

struct CustomHabit: Identifiable, Codable {
    let id: UUID
    let name: String
    let icon: String
    
    init(id: UUID = UUID(), name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}

#Preview {
    SettingsView()
}
