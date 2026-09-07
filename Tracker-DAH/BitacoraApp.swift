import SwiftUI
import SwiftData

@main
struct BitacoraApp: App {
    init() {
        configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .tint(Theme.accent)
                .task {
                    // Migración one-time de escala 0-10 a 1-5
                    await performScaleMigrationIfNeeded()
                }
        }
        .modelContainer(for: [DayEntry.self, ActivityItem.self, RecurringAppointment.self])
    }
    
    private func configureAppearance() {
        #if os(iOS)
        // Configurar TabBar con color de papel
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "PaperBackground")
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Configurar NavigationBar con color de papel
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(named: "PaperBackground")
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(named: "Ink") ?? .label
        ]
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "Ink") ?? .label
        ]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        #endif
    }
    
    @MainActor
    private func performScaleMigrationIfNeeded() async {
        guard let container = try? ModelContainer(
            for: DayEntry.self, ActivityItem.self, RecurringAppointment.self
        ) else { return }
        
        let context = ModelContext(container)
        
        do {
            try await ScaleMigration.migrateIfNeeded(context: context)
        } catch {
            print("❌ Error en migración de escala: \(error)")
        }
    }
}

// MARK: - Textura de papel global

struct PaperTextureBackground: View {
    var body: some View {
        ZStack {
            Theme.paperBackground
                .ignoresSafeArea()
            
            // Textura de grano de papel (placeholder, generarás la imagen después)
            Theme.paperGrainTexture
                .resizable(resizingMode: .tile)
                .blendMode(.multiply)
                .opacity(Theme.paperGrainOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
    }
}

// MARK: - Paleta estilo "cuaderno de papel" (Muji-inspired)

enum Theme {
    // MARK: Color Assets (definidos en Assets.xcassets/Colors/)
    static let paperBackground = Color("PaperBackground")  // Crudo/kraft claro | Marrón oscuro cálido
    static let accent = Color("Accent")                    // Verde salvia apagado
    static let ink = Color("Ink")                          // Marrón-negro cálido | Crema
    static let inkMuted = Color("InkMuted")                // Versión atenuada del ink
    static let hairline = Color("Hairline")                // Borde sutil, casi invisible
    static let card = Color("Card")                        // Levemente distinto de paper
    
    // MARK: Tipografía
    static let serifFont: Font.Design = .serif
    static let sansFont: Font.Design = .default
    
    // MARK: Border radius (esquinas pequeñas, estilo cuaderno)
    static let cornerRadiusSmall: CGFloat = 4
    static let cornerRadiusMedium: CGFloat = 6
    
    // MARK: Textura de papel (imagen en Assets.xcassets/Textures/)
    static let paperGrainTexture = Image("PaperGrain")
    static let paperGrainOpacity: Double = 0.06
    
    /// Verde salvia con intensidad según la puntuación (1-5).
    /// Respeta el esquema de color (light/dark mode) usando variaciones del accent.
    static func shade(for value: Int?, colorScheme: ColorScheme) -> Color {
        guard let value else { return hairline }
        // Normalizar 1-5 a 0.0-1.0
        let intensity = Double(value - 1) / 4.0
        
        if colorScheme == .dark {
            // En dark mode, usar opacidades más altas para mantener visibilidad
            let opacity = 0.5 + (intensity * 0.5) // Rango: 0.5 a 1.0
            return accent.opacity(opacity)
        } else {
            // En light mode, opacidades más sutiles
            let opacity = 0.3 + (intensity * 0.5) // Rango: 0.3 a 0.8
            return accent.opacity(opacity)
        }
    }
}
