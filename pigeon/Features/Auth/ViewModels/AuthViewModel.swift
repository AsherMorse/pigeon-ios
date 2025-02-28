import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published private(set) var formState: AuthFormState = .idle
    @Published var authState: AuthViewState = .login
    
    func updateFormState(_ newState: AuthFormState) {
        formState = newState
    }
    
    func switchToRegister() { authState = .register }
    func switchToLogin() { authState = .login }
} 
