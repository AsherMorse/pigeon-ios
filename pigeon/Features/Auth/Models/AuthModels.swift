import Foundation

enum APIErrorCode: String, Codable {
    case validationError = "VALIDATION_ERROR"
    case invalidCredentials = "INVALID_CREDENTIALS"
    case invalidToken = "INVALID_TOKEN"
    case invalidRefreshToken = "INVALID_REFRESH_TOKEN"
    case resourceExists = "RESOURCE_EXISTS"
    case internalError = "INTERNAL_ERROR"
    case sessionExpired = "SESSION_EXPIRED"
    case unknownError = "UNKNOWN_ERROR"
}

struct APIResponse<T: Codable>: Codable {
    let status: String
    let message: String?
    let data: T?
    let code: String?
    let errors: [FieldError]?
}

struct FieldError: Codable {
    let field: String
    let message: String
    let code: String?
}

struct User: Codable, Identifiable, Equatable {
    let id: String
    let username: String
    let email: String

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

struct AuthTokens: Codable {
    let accessToken: String
    let refreshToken: String
    let user: User?
}

struct LoginRequest: Codable {
    let credential: String
    let password: String
}

struct RegisterRequest: Codable {
    let username: String
    let email: String
    let password: String
}

struct LogoutRequest: Codable {
    let refreshToken: String
}

struct RefreshTokenRequest: Codable {
    let refreshToken: String
}

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

struct EmptyResponse: Codable {}
