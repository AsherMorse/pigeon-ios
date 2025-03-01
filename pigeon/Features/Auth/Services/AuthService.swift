import Foundation

final class AuthService {
    private let baseURL: URL
    
    init(baseURL: URL? = URL(string: Secrets.apiBaseURL)) {
        guard let baseURL = baseURL else {
            fatalError("Invalid API base URL configuration")
        }
        self.baseURL = baseURL
    }
    
    func register(username: String, email: String, password: String) async throws -> AuthTokens {
        let request = RegisterRequest(username: username, email: email, password: password)
        let url = baseURL.appendingPathComponent("auth/register")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.networkError(NSError(domain: "Invalid response", code: -1))
        }
        
        return try AuthErrorHandling.processResponse(
            data: data,
            httpResponse: httpResponse,
            decodingType: AuthTokens.self
        )
    }
    
    func login(credential: String, password: String) async throws -> AuthTokens {
        let request = LoginRequest(credential: credential, password: password)
        let url = baseURL.appendingPathComponent("auth/login")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.networkError(NSError(domain: "Invalid response", code: -1))
        }
        
        return try AuthErrorHandling.processResponse(
            data: data,
            httpResponse: httpResponse,
            decodingType: AuthTokens.self
        )
    }
    
    func logout(refreshToken: String) async throws {
        let request = LogoutRequest(refreshToken: refreshToken)
        let url = baseURL.appendingPathComponent("auth/logout")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
            return
        }
    }
    
    func refreshToken(refreshToken: String) async throws -> AuthTokens {
        let request = RefreshTokenRequest(refreshToken: refreshToken)
        let url = baseURL.appendingPathComponent("auth/refresh")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.networkError(NSError(domain: "Invalid response", code: -1))
        }
        
        return try AuthErrorHandling.processResponse(
            data: data,
            httpResponse: httpResponse,
            decodingType: AuthTokens.self
        )
    }
    
    func validateSession(accessToken: String) async throws -> User {
        let url = baseURL.appendingPathComponent("auth/session")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.networkError(NSError(domain: "Invalid response", code: -1))
        }
        
        return try AuthErrorHandling.processResponse(
            data: data,
            httpResponse: httpResponse,
            decodingType: User.self
        )
    }
}
