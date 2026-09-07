import SwiftUI
import SwiftData

// MARK: - Vista principal de citas recurrentes

struct AppointmentsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \RecurringAppointment.nextDate) private var appointments: [RecurringAppointment]
    
    @State private var appointmentManager = AppointmentManager()
    @State private var showingAddSheet = false
    @State private var showingPermissionSheet = false
    @State private var showingNextDateSheet = false
    @State private var selectedAppointment: RecurringAppointment?
    @State private var permissionAsked = UserDefaults.standard.bool(forKey: "appointmentPermissionAsked")
    
    private var scheduled: [RecurringAppointment] {
        appointments.filter { $0.isScheduled }.sorted { ($0.nextDate ?? .distantFuture) < ($1.nextDate ?? .distantFuture) }
    }
    
    private var unscheduled: [RecurringAppointment] {
        appointments.filter { !$0.isScheduled }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if !scheduled.isEmpty {
                    Section {
                        ForEach(scheduled) { appointment in
                            AppointmentRow(
                                appointment: appointment,
                                onComplete: {
                                    completeAppointment(appointment)
                                }
                            )
                        }
                        .onDelete { indexSet in
                            deleteAppointments(at: indexSet, from: scheduled)
                        }
                    } header: {
                        Text(L10n.appointmentsUpcoming)
                            .font(.system(.subheadline, design: .serif))
                            .foregroundStyle(Theme.ink)
                    }
                    .listRowBackground(Theme.card)
                }
                
                if !unscheduled.isEmpty {
                    Section {
                        ForEach(unscheduled) { appointment in
                            AppointmentRow(
                                appointment: appointment,
                                onComplete: {
                                    completeAppointment(appointment)
                                }
                            )
                        }
                        .onDelete { indexSet in
                            deleteAppointments(at: indexSet, from: unscheduled)
                        }
                    } header: {
                        Text(L10n.appointmentsUnscheduled)
                            .font(.system(.subheadline, design: .serif))
                            .foregroundStyle(Theme.ink)
                    }
                    .listRowBackground(Theme.card)
                }
                
                if appointments.isEmpty {
                    ContentUnavailableView(
                        L10n.appointmentsEmpty,
                        systemImage: "calendar.badge.clock",
                        description: Text(L10n.appointmentsEmptyDescription)
                    )
                }
            }
            .scrollContentBackground(.hidden)
            .background {
                PaperTextureBackground()
                    .compositingGroup()
            }
            .navigationTitle(L10n.appointments)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.done) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddAppointmentSheet(
                    appointmentManager: appointmentManager,
                    showingPermissionSheet: $showingPermissionSheet,
                    permissionAsked: $permissionAsked
                )
            }
            .sheet(item: $selectedAppointment) { appointment in
                NextDateSheet(
                    appointment: appointment,
                    appointmentManager: appointmentManager
                )
            }
            .sheet(isPresented: $showingPermissionSheet) {
                PermissionExplanationSheet(
                    appointmentManager: appointmentManager,
                    permissionAsked: $permissionAsked
                )
            }
            .onAppear {
                appointmentManager.checkCalendarPermission()
            }
        }
    }

    // MARK: - Actions
    
    private func completeAppointment(_ appointment: RecurringAppointment) {
        appointment.lastCompletedDate = Date()
        selectedAppointment = appointment
    }
    
    private func deleteAppointments(at offsets: IndexSet, from array: [RecurringAppointment]) {
        Task {
            for index in offsets {
                let appointment = array[index]
                
                // Borrar evento de calendario si existe
                if let eventId = appointment.eventKitIdentifier {
                    try? await appointmentManager.deleteCalendarEvent(identifier: eventId)
                }
                
                // Cancelar notificaciones locales
                await appointmentManager.cancelLocalNotifications(for: appointment)
                
                // Borrar de SwiftData
                context.delete(appointment)
            }
        }
    }
}

// MARK: - Fila de cita

struct AppointmentRow: View {
    let appointment: RecurringAppointment
    let onComplete: () -> Void
    
    private var formattedDate: String {
        guard let date = appointment.nextDate else { return "—" }
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private var isPastDue: Bool {
        appointment.isPastDue
    }
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(appointment.title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.ink)
                
                if appointment.isScheduled {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(formattedDate)
                            .font(.caption)
                    }
                    .foregroundStyle(isPastDue ? Theme.accent : Theme.inkMuted)
                } else {
                    Text(L10n.appointmentsNoDate)
                        .font(.caption)
                        .italic()
                        .foregroundStyle(Theme.inkMuted)
                }
                
                if !appointment.notes.isEmpty {
                    Text(appointment.notes)
                        .font(.caption)
                        .foregroundStyle(Theme.inkMuted)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Button {
                onComplete()
            } label: {
                Text(L10n.appointmentsCompleted)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Theme.accent, in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Sheet para añadir cita

struct AddAppointmentSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    let appointmentManager: AppointmentManager
    @Binding var showingPermissionSheet: Bool
    @Binding var permissionAsked: Bool
    
    @State private var title = ""
    @State private var notes = ""
    @State private var hasDate = false
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L10n.appointmentsTitle)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Theme.ink)
                        
                        PlainTextField(placeholder: L10n.appointmentsTitle, text: $title)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L10n.appointmentsNotes)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Theme.ink)
                        
                        TextEditor(text: $notes)
                            .frame(minHeight: 80)
                            .scrollContentBackground(.hidden)
                            .padding(8)
                            .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
                            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall).stroke(Theme.hairline, lineWidth: 1))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle(L10n.appointmentsScheduleNow, isOn: $hasDate.animation(.easeOut(duration: 0.15)))
                            .padding(12)
                            .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
                            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
                        
                        if hasDate {
                            DatePicker(
                                L10n.appointmentsDate,
                                selection: $selectedDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.compact)
                            .padding(12)
                            .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
                            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    
                    Button {
                        createAppointment()
                    } label: {
                        Text(L10n.appointmentsCreate)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(Theme.accent, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
                    }
                    .buttonStyle(.plain)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(title.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
                }
                .padding(20)
            }
            .background {
                PaperTextureBackground()
                    .compositingGroup()
            }
            .navigationTitle(L10n.appointmentsNewAppointment)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.cancel) {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private func createAppointment() {
        let appointment = RecurringAppointment(
            title: title.trimmingCharacters(in: .whitespaces),
            nextDate: hasDate ? selectedDate : nil,
            notes: notes.trimmingCharacters(in: .whitespaces)
        )
        
        context.insert(appointment)
        
        // Si tiene fecha, preguntar por permisos si no se ha hecho
        if hasDate && !permissionAsked {
            showingPermissionSheet = true
            permissionAsked = true
            UserDefaults.standard.set(true, forKey: "appointmentPermissionAsked")
        } else if hasDate {
            // Ya tenemos permisos, crear evento/notificación
            Task {
                do {
                    let eventId = try await appointmentManager.scheduleAppointment(appointment)
                    appointment.eventKitIdentifier = eventId
                } catch {
                    print("Error scheduling appointment: \(error)")
                }
            }
        }
        
        dismiss()
    }
}

// MARK: - Sheet de permisos explicativo

struct PermissionExplanationSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    let appointmentManager: AppointmentManager
    @Binding var permissionAsked: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 40)
                    
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 64).weight(.light))
                        .foregroundStyle(Theme.accent)
                    
                    Text(L10n.appointmentsPermissionTitle)
                        .font(.system(.title2, design: .serif).weight(.medium))
                        .foregroundStyle(Theme.ink)
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(L10n.appointmentsPermissionDescription)
                            .font(.body)
                            .foregroundStyle(Theme.ink)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle")
                                    .font(.body.weight(.light))
                                    .foregroundStyle(Theme.accent)
                                    .frame(width: 20)
                                Text(L10n.appointmentsPermission1Day)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.ink)
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle")
                                    .font(.body.weight(.light))
                                    .foregroundStyle(Theme.accent)
                                    .frame(width: 20)
                                Text(L10n.appointmentsPermission1Hour)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.ink)
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle")
                                    .font(.body.weight(.light))
                                    .foregroundStyle(Theme.accent)
                                    .frame(width: 20)
                                Text(L10n.appointmentsPermissionAfter)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.ink)
                            }
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                    
                    VStack(spacing: 12) {
                        Button {
                            Task {
                                await requestCalendarPermission()
                            }
                        } label: {
                            Text(L10n.appointmentsPermissionGrant)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Theme.accent, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            Task {
                                await requestNotificationPermission()
                            }
                        } label: {
                            Text(L10n.appointmentsPermissionNotificationsOnly)
                                .font(.subheadline)
                                .foregroundStyle(Theme.accent)
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
                                .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.accent, lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .padding(20)
            }
            .background {
                PaperTextureBackground()
                    .compositingGroup()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.done) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    @MainActor
    private func requestCalendarPermission() async {
        let granted = await appointmentManager.requestCalendarAccess()
        if granted {
            dismiss()
        }
    }
    
    @MainActor
    private func requestNotificationPermission() async {
        let granted = await appointmentManager.requestNotificationAccess()
        if granted {
            dismiss()
        }
    }
}

// MARK: - Sheet de próxima fecha

struct NextDateSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    let appointment: RecurringAppointment
    let appointmentManager: AppointmentManager
    
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text(L10n.appointmentsNextQuestion(appointment.title))
                        .font(.system(.title3, design: .serif).weight(.medium))
                        .foregroundStyle(Theme.ink)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    DatePicker(
                        L10n.appointmentsDate,
                        selection: $selectedDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical)
                    .padding(16)
                    .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
                    .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium).stroke(Theme.hairline, lineWidth: 1))
                    
                    Spacer(minLength: 40)
                    
                    VStack(spacing: 12) {
                        Button {
                            scheduleNext()
                        } label: {
                            Text(L10n.appointmentsSchedule)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Theme.accent, in: RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium))
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            skipForNow()
                        } label: {
                            Text(L10n.appointmentsDontKnow)
                                .font(.subheadline)
                                .foregroundStyle(Theme.inkMuted)
                                .padding(12)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal, 20)
            }
            .background {
                PaperTextureBackground()
                    .compositingGroup()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
        .presentationDetents([.medium, .large])
    }
    
    private func scheduleNext() {
        appointment.nextDate = selectedDate
        
        Task {
            do {
                if appointment.eventKitIdentifier != nil {
                    // Actualizar evento existente
                    try await appointmentManager.updateCalendarEvent(for: appointment)
                } else {
                    // Crear nuevo evento
                    let eventId = try await appointmentManager.scheduleAppointment(appointment)
                    appointment.eventKitIdentifier = eventId
                }
            } catch {
                print("Error scheduling next appointment: \(error)")
            }
        }
        
        dismiss()
    }
    
    private func skipForNow() {
        appointment.nextDate = nil
        dismiss()
    }
}

#Preview {
    AppointmentsView()
        .modelContainer(for: [DayEntry.self, ActivityItem.self, RecurringAppointment.self], inMemory: true)
}
