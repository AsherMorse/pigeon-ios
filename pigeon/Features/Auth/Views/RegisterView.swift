import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                AuthInput(
                    title: "Username",
                    text: $viewModel.username,
                    contentType: .username,
                    isSecure: false,
                    keyboardType: .default
                )
                
                AuthInput(
                    title: "Email",
                    text: $viewModel.email,
                    contentType: .emailAddress,
                    isSecure: false,
                    keyboardType: .emailAddress
                )
                
                AuthInput(
                    title: "Password",
                    text: $viewModel.password,
                    contentType: .newPassword,
                    isSecure: true,
                    keyboardType: .default
                )
            }
            
            if case .error(let message) = viewModel.formState {
                Text(message)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            PigeonButton(
                title: "Sign Up",
                isLoading: viewModel.formState == .loading,
                action: viewModel.handleRegister
            )
            
            PigeonButton(
                title: "Already have an account?",
                style: .text,
                action: viewModel.switchToLogin
            )
        }
        .padding()
        .navigationTitle("Register")
    }
} 
