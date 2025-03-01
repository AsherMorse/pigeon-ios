import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var authState: AuthViewState = .login
    
    // Login fields
    @Published var credential = ""
    @Published var password = ""
    
    // Register fields
    @Published var username = ""
    @Published var email = ""
    @Published var registerPassword = ""
    
    // MARK: - Private Properties
    private let alertManager = AlertManager.shared
    private var authTask: Task<Void, Never>?
    
    // MARK: - Public Methods
    func handleAuthAction() {
        authTask?.cancel()
        authTask = Task {
            switch authState {
            case .login:
                await login()
            case .register:
                await register()
            }
        }
    }
    
    func switchToRegister() { 
        resetFields()
        authState = .register 
    }
    
    func switchToLogin() { 
        resetFields()
        authState = .login 
    }
    
    // MARK: - Private Methods
    private func login() async {
        switch AuthValidation.validateLogin(credential: credential, password: password) {
        case .failure(let error):
            presentValidationError(error)
            return
        case .success:
            break
        }
        
        do {
            let user = try await AuthManager.shared.login(
                credential: credential,
                password: password
            )
            presentSuccess(
                message: "Successfully logged in as \(user.username)",
                title: "Welcome Back"
            )
        } catch {
            presentError(error)
        }
    }
    
    private func register() async {
        switch AuthValidation.validateRegister(
            username: username,
            email: email,
            password: registerPassword
        ) {
        case .failure(let error):
            presentValidationError(error)
            return
        case .success:
            break
        }
        
        do {
            let user = try await AuthManager.shared.register(
                username: username,
                email: email,
                password: registerPassword
            )
            presentSuccess(
                message: "Successfully registered as \(user.username)",
                title: "Welcome"
            )
        } catch {
            presentError(error)
        }
    }
    
    private func resetFields() {
        credential = ""
        password = ""
        
        username = ""
        email = ""
        registerPassword = ""
    }
    
    private func presentError(_ error: Error, title: String = "Error") {
        if let authError = error as? AuthError {
            alertManager.present(authError)
        } else {
            alertManager.present(
                message: error.localizedDescription,
                title: title,
                style: .error
            )
        }
    }
    
    private func presentValidationError(_ error: AuthValidationError) {
        alertManager.present(
            message: error.localizedDescription,
            title: "Validation Error",
            style: .warning
        )
    }
    
    private func presentSuccess(message: String, title: String) {
        alertManager.present(
            message: message,
            title: title,
            style: .success
        )
    }
    
    deinit {
        authTask?.cancel()
    }
} 
