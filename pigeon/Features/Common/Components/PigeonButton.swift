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
                .font(style.font)
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
        case text
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return .blue
            case .secondary:
                return .gray.opacity(0.2)
            case .text:
                return .clear
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary:
                return .white
            case .secondary, .text:
                return .primary
            }
        }
        
        var font: Font {
            switch self {
            case .primary, .secondary:
                return .headline
            case .text:
                return .body
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
        
        PigeonButton(title: "Text Button", style: .text) {
            print("Text tapped")
        }
    }
    .padding()
}
