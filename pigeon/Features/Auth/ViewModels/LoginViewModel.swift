import SwiftUI

@MainActor
final class LoginViewModel: AuthViewModel {
    @Published var credential = ""
    @Published var password = ""
    
    private let alertManager = AlertManager.shared
    private var loginTask: Task<Void, Never>?
    
    func handleLogin() {
        loginTask?.cancel()
        loginTask = Task { await login() }
    }
    
    private func login() async {
        switch AuthValidation.validateLogin(credential: credential, password: password) {
        case .failure(let error):
            alertManager.present(
                message: error.localizedDescription,
                title: "Validation Error",
                style: .warning
            )
            return
        case .success:
            break
        }
        
        do {
            let user = try await AuthManager.shared.login(
                credential: credential,
                password: password
            )
            alertManager.present(
                message: "Successfully logged in as \(user.username)",
                title: "Welcome Back",
                style: .success
            )
        } catch let authError as AuthError {
            alertManager.present(authError)
        } catch {
            alertManager.present(
                message: error.localizedDescription,
                title: "Error",
                style: .error
            )
        }
    }
    
    deinit {
        loginTask?.cancel()
    }
} 
