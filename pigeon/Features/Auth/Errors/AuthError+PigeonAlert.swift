import Foundation

enum AuthError: LocalizedError {
    case invalidCredentials
    case networkError(Error)
    case validationError(message: String)
    case resourceExists(message: String)
    case serverError(message: String)
    case sessionExpired
    case invalidToken
    case invalidRefreshToken
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid credentials"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .validationError(let message):
            return message
        case .resourceExists(let message):
            return message
        case .serverError(let message):
            return "Server error: \(message)"
        case .sessionExpired:
            return "Session expired"
        case .invalidToken:
            return "Invalid token"
        case .invalidRefreshToken:
            return "Invalid refresh token"
        case .unknown:
            return "Unknown error"
        }
    }
}

extension AuthError: PigeonAlert {
    var title: String {
        switch self {
        case .invalidCredentials:
            return "Login Failed"
        case .networkError:
            return "Connection Error"
        case .validationError:
            return "Invalid Input"
        case .resourceExists:
            return "Account Exists"
        case .serverError:
            return "Server Error"
        case .sessionExpired:
            return "Session Expired"
        case .invalidToken, .invalidRefreshToken:
            return "Authentication Error"
        case .unknown:
            return "Error"
        }
    }
    
    // We already have description through LocalizedError
    var description: String {
        return errorDescription ?? "An unknown error occurred"
    }
    
    var style: AlertStyle {
        switch self {
        case .invalidCredentials, .validationError, .resourceExists:
            return .warning
        case .networkError, .serverError, .unknown:
            return .error
        case .sessionExpired, .invalidToken, .invalidRefreshToken:
            return .info
        }
    }
    
    var details: [String: String]? {
        switch self {
        case .networkError(let error):
            return ["underlying_error": error.localizedDescription]
        case .serverError(let message):
            return ["server_message": message]
        default:
            return nil
        }
    }
} 
