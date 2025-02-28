import SwiftUI

struct AuthView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var registerViewModel = RegisterViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch loginViewModel.authState {
                case .login:
                    LoginView(viewModel: loginViewModel)
                case .register:
                    RegisterView(viewModel: registerViewModel)
                }
            }
        }
    }
}

#Preview {
    AuthView()
}
