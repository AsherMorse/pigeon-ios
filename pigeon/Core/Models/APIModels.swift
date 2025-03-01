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
    let errors: [ValidationError]?
}

struct ValidationError: Codable {
    let field: String
    let message: String
    let code: String?
}

struct EmptyResponse: Codable {} 
