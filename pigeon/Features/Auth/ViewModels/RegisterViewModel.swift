import SwiftUI

@MainActor
final class RegisterViewModel: AuthViewModel {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
    private let alertManager = AlertManager.shared
    private var registrationTask: Task<Void, Never>?
    
    func handleRegister() {
        registrationTask?.cancel()
        registrationTask = Task { await register() }
    }
    
    private func register() async {
        switch AuthValidation.validateRegister(
            username: username,
            email: email,
            password: password
        ) {
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
            let user = try await AuthManager.shared.register(
                username: username,
                email: email,
                password: password
            )
            alertManager.present(
                message: "Successfully registered as \(user.username)",
                title: "Welcome",
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
        registrationTask?.cancel()
    }
} 
