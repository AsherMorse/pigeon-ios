import SwiftUI

struct PigeonAuthField: View {
    let title: String
    let placeholder: String
    let systemImage: String
    @Binding var text: String
    var isSecure: Bool = false
    var autocapitalization: TextInputAutocapitalization = .never
    var keyboardType: UIKeyboardType = .default
    
    @State private var isShowingSecureText: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary.opacity(0.8))
            
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                
                Group {
                    if isSecure && !isShowingSecureText {
                        SecureField(placeholder, text: $text)
                            .textContentType(isSecure ? .password : .none)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .disableAutocorrection(true)
                .keyboardType(keyboardType)
                
                if isSecure {
                    Button(action: {
                        isShowingSecureText.toggle()
                    }) {
                        Image(systemName: isShowingSecureText ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    VStack {
        PigeonAuthField(
            title: "Email",
            placeholder: "Enter your email",
            systemImage: "envelope",
            text: .constant(""),
            keyboardType: .emailAddress
        )
        
        PigeonAuthField(
            title: "Password",
            placeholder: "Enter your password",
            systemImage: "lock",
            text: .constant("password123"),
            isSecure: true
        )
        
        PigeonAuthField(
            title: "Username",
            placeholder: "Choose a username",
            systemImage: "person",
            text: .constant("pigeon_user")
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
} 
