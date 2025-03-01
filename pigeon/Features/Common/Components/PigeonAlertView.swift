import SwiftUI

struct PigeonAlertView: View {
    let alert: PigeonAlert
    let onDismiss: () -> Void
    
    @State private var offset: CGFloat = -100
    @State private var opacity: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: alert.style.iconName)
                    .foregroundStyle(alert.style.color)
                
                Text(alert.title)
                    .font(.headline)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .foregroundStyle(.secondary)
                }
            }
            
            Text(alert.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let details = alert.details {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(details.sorted(by: { $0.key < $1.key })), id: \.key) { key, value in
                        HStack {
                            Text(key)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text(value)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.background)
                .shadow(color: Color.primary.opacity(0.15), radius: 10, y: 5)
        }
        .offset(y: offset)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                offset = 0
                opacity = 1
            }
        }
        .onTapGesture {
            onDismiss()
        }
    }
}

#Preview {
    VStack {
        PigeonAlertView(
            alert: GenericPigeonAlert(
                title: "Test Alert",
                description: "This is a test alert with some details",
                style: .info
            ),
            onDismiss: {}
        )
        
        PigeonAlertView(
            alert: GenericPigeonAlert(
                title: "Error Occurred",
                description: "Something went wrong while processing your request",
                style: .error
            ),
            onDismiss: {}
        )
        
        PigeonAlertView(
            alert: GenericPigeonAlert(
                title: "Success!",
                description: "Operation completed successfully",
                style: .success
            ),
            onDismiss: {}
        )
    }
    .padding()
} 