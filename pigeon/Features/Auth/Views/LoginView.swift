import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome Back")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                AuthInput(
                    title: "Email or Username",
                    text: $viewModel.credential,
                    contentType: .emailAddress,
                    isSecure: false,
                    keyboardType: .emailAddress
                )
                
                AuthInput(
                    title: "Password",
                    text: $viewModel.password,
                    contentType: .password,
                    isSecure: true,
                    keyboardType: .default
                )
            }
            
            PigeonButton(
                title: "Sign In",
                action: viewModel.handleLogin
            )
            
            Button("Don't have an account? Register") {
                authViewModel.switchToRegister()
            }
        }
        .padding()
        .navigationTitle("Login")
    }
} 
