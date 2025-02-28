import SwiftUI

@MainActor
final class RegisterViewModel: AuthViewModel {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
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
            print("Validation failure: \(error)")
            return
        case .success:
            break
        }
        
        updateFormState(.loading)
        
        do {
            let user = try await AuthManager.shared.register(
                username: username,
                email: email,
                password: password
            )
            print("Registered as: \(user.username)")
        } catch let authError as AuthError {
            print("Registration auth failure: \(authError)")
        } catch {
            print("Registration failure: \(error)")
        }
    }
    
    deinit {
        registrationTask?.cancel()
    }
} 
