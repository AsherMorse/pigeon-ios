import SwiftUI

@MainActor
final class LoginViewModel: AuthViewModel {
    @Published var credential = ""
    @Published var password = ""
    
    private var loginTask: Task<Void, Never>?
    
    func handleLogin() {
        loginTask?.cancel()
        loginTask = Task { await login() }
    }
    
    private func login() async {
        switch AuthValidation.validateLogin(credential: credential, password: password) {
        case .failure(let error):
            print("Validation error: \(error)")
            return
        case .success:
            break
        }
        
        do {
            let user = try await AuthManager.shared.login(
                credential: credential,
                password: password
            )
            print("Logged in as: \(user.username)")
        } catch let authError as AuthError {
            print("Login auth failure: \(authError)")
        } catch {
            print("Login failure: \(error)")
        }

    }
    
    deinit {
        loginTask?.cancel()
    }
} 
