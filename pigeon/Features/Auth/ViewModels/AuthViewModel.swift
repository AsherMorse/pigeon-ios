import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var authState: AuthViewState = .login
    
    func switchToRegister() { authState = .register }
    func switchToLogin() { authState = .login }
} 
