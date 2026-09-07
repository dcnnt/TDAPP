import SwiftUI

// TEST: Verificar que los Color Sets funcionan
struct ColorTestView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Verificación de Color Sets")
                .font(.title)
            
            Group {
                ColorRow(name: "PaperBackground", color: Color("PaperBackground"))
                ColorRow(name: "Accent", color: Color("Accent"))
                ColorRow(name: "Ink", color: Color("Ink"))
                ColorRow(name: "InkMuted", color: Color("InkMuted"))
                ColorRow(name: "Hairline", color: Color("Hairline"))
                ColorRow(name: "Card", color: Color("Card"))
            }
            
            Spacer()
        }
        .padding()
    }
}

struct ColorRow: View {
    let name: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(name)
                .frame(width: 150, alignment: .leading)
            
            Rectangle()
                .fill(color)
                .frame(width: 100, height: 40)
                .border(Color.black, width: 1)
            
            Text("✓ OK")
                .foregroundColor(.green)
        }
    }
}

#Preview {
    ColorTestView()
}
