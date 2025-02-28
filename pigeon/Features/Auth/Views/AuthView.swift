import SwiftUI

struct AuthView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var registerViewModel = RegisterViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch authViewModel.authState {
                case .login:
                    LoginView(viewModel: loginViewModel, authViewModel: authViewModel)
                case .register:
                    RegisterView(viewModel: registerViewModel, authViewModel: authViewModel)
                }
            }
        }
    }
}

#Preview {
    AuthView()
}
