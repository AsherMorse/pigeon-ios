import Foundation

struct FieldError: Codable {
    let field: String
    let message: String
    let code: String?
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
