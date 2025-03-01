import Foundation

struct AuthErrorHandling {
    static func processResponse<T: Codable>(
        data: Data,
        httpResponse: HTTPURLResponse,
        decodingType: T.Type
    ) throws -> T {
        do {
            let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
            
            switch httpResponse.statusCode {
            case 200, 201:
                guard let result = apiResponse.data else {
                    throw AuthError.serverError(message: "Missing data in response")
                }
                return result
                
            case 400:
                if apiResponse.code == APIErrorCode.validationError.rawValue {
                    throw AuthError.validationError(message: extractValidationErrorMessage(from: apiResponse))
                } else {
                    throw AuthError.serverError(message: "Bad Request \(httpResponse.statusCode)")
                }
                
            case 401:
                if apiResponse.code == APIErrorCode.invalidToken.rawValue {
                    throw AuthError.invalidToken
                } else if apiResponse.code == APIErrorCode.invalidRefreshToken.rawValue {
                    throw AuthError.invalidRefreshToken
                } else {
                    throw AuthError.invalidCredentials
                }
                
            case 409:
                let message = apiResponse.message ?? "Account already exists"
                throw AuthError.resourceExists(message: message)
                
            default:
                let message = apiResponse.message ?? "Server error \(httpResponse.statusCode)"
                throw AuthError.serverError(message: message)
            }
        } catch let decodingError as DecodingError {
            throw AuthError.serverError(message: "Server error \(httpResponse.statusCode) - Unable to decode response")
        } catch let authError as AuthError {
            throw authError
        } catch {
            throw AuthError.serverError(message: "Server error \(httpResponse.statusCode)")
        }
    }
    
    private static func extractValidationErrorMessage<T>(from response: APIResponse<T>) -> String {
        if let firstError = response.errors?.first {
            return "\(firstError.field): \(firstError.message)"
        } else if let message = response.message {
            return message
        }
        return "Validation failed"
    }
}
