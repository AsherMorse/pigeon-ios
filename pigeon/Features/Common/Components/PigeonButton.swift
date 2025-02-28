import SwiftUI

struct PigeonButton: View {
    let title: String
    let style: Style
    let action: () -> Void
    
    init(
        title: String,
        style: Style = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: style.maxWidth ? .infinity : nil)
        .padding(.vertical, style.verticalPadding)
        .padding(.horizontal, style.horizontalPadding)
        .background(style.backgroundColor)
        .foregroundColor(style.foregroundColor)
        .cornerRadius(style.cornerRadius)
    }
}

extension PigeonButton {
    enum Style {
        case primary
        case secondary
        case text
        
        var backgroundColor: Color {
            switch self {
            case .primary: return .blue
            case .secondary: return .gray.opacity(0.1)
            case .text: return .clear
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary: return .white
            case .secondary, .text: return .blue
            }
        }
        
        var tintColor: Color {
            switch self {
            case .primary: return .white
            case .secondary, .text: return .blue
            }
        }
        
        var cornerRadius: CGFloat { 10 }
        var verticalPadding: CGFloat { 16 }
        var horizontalPadding: CGFloat { 16 }
        var maxWidth: Bool {
            switch self {
            case .primary, .secondary: return true
            case .text: return false
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PigeonButton(title: "Primary Button", style: .primary) {}
        PigeonButton(title: "Secondary Button", style: .secondary) {}
        PigeonButton(title: "Text Button", style: .text) {}
    }
    .padding()
} 
