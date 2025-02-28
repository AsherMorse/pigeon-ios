import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel
    @ObservedObject var authViewModel: AuthViewModel
    
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
            
            PigeonButton(
                title: "Sign Up",
                action: viewModel.handleRegister
            )
            
            Button("Already have an account? Login") {
                authViewModel.switchToLogin()
            }
        }
        .padding()
        .navigationTitle("Register")
    }
} 
