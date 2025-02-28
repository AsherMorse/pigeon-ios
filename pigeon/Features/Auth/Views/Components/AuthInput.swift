import SwiftUI

struct AuthInput: View {
    let title: String
    @Binding var text: String
    let contentType: UITextContentType?
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
            }
        }
        .textFieldStyle(.roundedBorder)
        .textContentType(contentType)
        .autocapitalization(.none)
        .keyboardType(keyboardType)
        .padding(.horizontal)
    }
} 
