import SwiftUI

#if os(iOS)
import UIKit
#endif

// MARK: - Puntuación 1–5

/// Cinco opciones. Tocas para puntuar, vuelves a tocar el mismo para borrarlo.
struct RatingPicker: View {
    let label: String
    @Binding var value: Int?
    
    private func ratingLabel(for value: Int) -> String {
        switch value {
        case 1: return L10n.rating1
        case 2: return L10n.rating2
        case 3: return L10n.rating3
        case 4: return L10n.rating4
        case 5: return L10n.rating5
        default: return "–"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline)
                Spacer()
                Text(value.map { ratingLabel(for: $0) } ?? "–")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(value == nil ? Theme.inkMuted : Theme.ink)
            }
            
            HStack(spacing: 0) {
                ForEach(1...5, id: \.self) { n in
                    Button {
                        withAnimation(.easeOut(duration: 0.12)) {
                            value = (value == n) ? nil : n
                        }
                        Haptics.tap()
                    } label: {
                        Circle()
                            .fill(value == n ? Theme.accent : Theme.card)
                            .overlay(Circle().stroke(Theme.hairline, lineWidth: 1))
                            .overlay(
                                Text("\(n)")
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(value == n ? .white : Theme.inkMuted)
                            )
                            .frame(width: 40, height: 40)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("\(label) \(n)")
                    
                    if n < 5 {
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 4)
        }
    }
}

// MARK: - Interruptor con campo que aparece debajo

struct ToggleRow<Content: View>: View {
    let label: String
    @Binding var isOn: Bool
    @ViewBuilder var detail: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Toggle(isOn: $isOn.animation(.easeOut(duration: 0.15))) {
                Text(label).font(.subheadline)
            }
            if isOn {
                detail
                    .transition(AnyTransition.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
    }
}

extension ToggleRow where Content == EmptyView {
    init(label: String, isOn: Binding<Bool>) {
        self.init(label: label, isOn: isOn) { EmptyView() }
    }
}

// MARK: - Campo de minutos

struct MinutesField: View {
    let placeholder: String
    @Binding var minutes: Int?

    var body: some View {
        let field = TextField(placeholder, value: $minutes, format: .number)
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.horizontal, 11)
            .padding(.vertical, 9)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.hairline, lineWidth: 1))
        
        #if os(iOS)
        return field.keyboardType(.numberPad)
        #else
        return field
        #endif
    }
}

struct PlainTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.horizontal, 11)
            .padding(.vertical, 9)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.hairline, lineWidth: 1))
    }
}

// MARK: - Cabecera de sección

struct SectionHeading: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(.headline, design: .serif))
            .foregroundStyle(Theme.ink)
            .padding(.bottom, 2)
    }
}

// MARK: - Tira de los últimos días

struct HistoryStrip: View {
    let days: [Date]
    let selected: Date
    /// Ánimo de cada día, para colorear el punto
    let moodFor: (Date) -> Int?
    let onSelect: (Date) -> Void
    
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView([.horizontal], showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(days, id: \.self) { day in
                        Button {
                            onSelect(day)
                        } label: {
                            VStack(spacing: 5) {
                                Circle()
                                    .fill(Theme.shade(for: moodFor(day), colorScheme: colorScheme))
                                    .overlay(Circle().stroke(Theme.hairline, lineWidth: 1))
                                    .frame(width: 22, height: 22)
                                    .overlay(
                                        Circle()
                                            .stroke(Theme.ink, lineWidth: 2)
                                            .padding(-3)
                                            .opacity(sameDay(day, selected) ? 1 : 0)
                                    )
                                Text(day.formatted(.dateTime.day()))
                                    .font(.caption2)
                                    .monospacedDigit()
                                    .foregroundStyle(Theme.inkMuted)
                            }
                            .frame(minWidth: 44, minHeight: 44)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        .id(day)
                    }
                }
                .padding(EdgeInsets(top: 6, leading: 2, bottom: 6, trailing: 2))
            }
            .onAppear { proxy.scrollTo(selected, anchor: .center) }
            .onChange(of: selected) { _, new in
                withAnimation { proxy.scrollTo(new, anchor: .center) }
            }
        }
    }

    private func sameDay(_ a: Date, _ b: Date) -> Bool {
        Calendar.current.isDate(a, inSameDayAs: b)
    }
}

// MARK: - Vibración corta al puntuar

enum Haptics {
    static func tap() {
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }
}
// MARK: - Sección colapsable

struct CollapsibleSection<Content: View>: View {
    let title: String
    let systemImage: String
    @Binding var isExpanded: Bool
    let badge: String?
    @ViewBuilder var content: Content

    init(
        title: String,
        systemImage: String,
        isExpanded: Binding<Bool>,
        badge: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.systemImage = systemImage
        self._isExpanded = isExpanded
        self.badge = badge
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
                Haptics.tap()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: systemImage)
                        .font(.body)
                        .foregroundStyle(Theme.accent)
                        .frame(width: 24)
                    
                    Text(title)
                        .font(.system(.headline, design: .serif))
                        .foregroundStyle(Theme.ink)
                    
                    if let badge {
                        Text(badge)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Theme.accent)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Theme.accent.opacity(0.12), in: Capsule())
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.inkMuted)
                        .rotationEffect(.degrees(isExpanded ? 0 : -90))
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isExpanded ? Theme.accent.opacity(0.3) : Theme.hairline, lineWidth: 1.5)
                )
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    content
                }
                .padding(.top, 16)
                .padding(.horizontal, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

