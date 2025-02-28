import Foundation

enum AuthValidationError: LocalizedError {
    case emptyUsername
    case emptyEmail
    case emptyPassword
    case emptyCredential
    
    var errorDescription: String? {
        switch self {
        case .emptyUsername:
            return "Please enter a username"
        case .emptyEmail:
            return "Please enter an email"
        case .emptyPassword:
            return "Please enter your password"
        case .emptyCredential:
            return "Please enter your email or username"
        }
    }
}

struct AuthValidation {
    static func validateLogin(
        credential: String,
        password: String
    ) -> Result<Void, AuthValidationError> {
        guard !credential.isEmpty else { return .failure(.emptyCredential) }
        guard !password.isEmpty else { return .failure(.emptyPassword) }
        return .success(())
    }
    
    static func validateRegister(
        username: String,
        email: String,
        password: String
    ) -> Result<Void, AuthValidationError> {
        guard !username.isEmpty else { return .failure(.emptyUsername) }
        guard !email.isEmpty else { return .failure(.emptyEmail) }
        guard !password.isEmpty else { return .failure(.emptyPassword) }
        return .success(())
    }
} 
