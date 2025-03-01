import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.authState {
                case .login:
                    loginView
                case .register:
                    registerView
                }
            }
        }
    }
    
    @ViewBuilder private var loginView: some View {
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
                action: viewModel.handleAuthAction
            )
            
            PigeonButton(
                title: "Need an account? Register",
                style: .text,
                action: viewModel.switchToRegister
            )
        }
        .padding()
        .navigationTitle("Login")
    }
    
    @ViewBuilder private var registerView: some View {
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
                    text: $viewModel.registerPassword,
                    contentType: .newPassword,
                    isSecure: true,
                    keyboardType: .default
                )
            }
            
            PigeonButton(
                title: "Sign Up",
                action: viewModel.handleAuthAction
            )
            
            PigeonButton(
                title: "Already have an account? Login",
                style: .text,
                action: viewModel.switchToLogin
            )
        }
        .padding()
        .navigationTitle("Register")
    }
}

#Preview {
    AuthView()
}
