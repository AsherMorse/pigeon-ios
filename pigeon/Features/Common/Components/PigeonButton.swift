import SwiftUI

struct PigeonButton: View {
    let title: String
    let action: () -> Void
    let style: ButtonStyle
    
    init(
        title: String,
        style: ButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(style.backgroundColor)
                .foregroundColor(style.foregroundColor)
                .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}

extension PigeonButton {
    enum ButtonStyle {
        case primary
        case secondary
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return .blue
            case .secondary:
                return .gray.opacity(0.2)
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary:
                return .white
            case .secondary:
                return .primary
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PigeonButton(title: "Primary Button") {
            print("Primary tapped")
        }
        
        PigeonButton(title: "Secondary Button", style: .secondary) {
            print("Secondary tapped")
        }
    }
    .padding()
}
