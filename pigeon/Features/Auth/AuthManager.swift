import Foundation
import SwiftUI

@Observable
final class AuthManager {
    static let shared = AuthManager()
    
    private(set) var state: AuthState = .unauthenticated
    private(set) var currentUser: User?
    private(set) var isCheckingInitialAuth = true
    
    private let authService: AuthService
    private let tokenManager: TokenManager
    
    private init(
        authService: AuthService = AuthService(),
        tokenManager: TokenManager = TokenManager()
    ) {
        self.authService = authService
        self.tokenManager = tokenManager
        
        Task {
            await checkAuthStatus()
            await MainActor.run {
                self.isCheckingInitialAuth = false
            }
        }
    }
    
    func register(username: String, email: String, password: String) async throws -> User {
        state = .loading
        
        do {
            let authTokens = try await authService.register(
                username: username,
                email: email,
                password: password
            )
            
            tokenManager.saveTokens(
                accessToken: authTokens.accessToken,
                refreshToken: authTokens.refreshToken
            )
            
            if let user = authTokens.user {
                await MainActor.run {
                    self.currentUser = user
                    self.state = .authenticated(user)
                }
                
                return user
            } else {
                return try await fetchUserWithSavedToken()
            }
        } catch {
            await MainActor.run {
                self.state = .unauthenticated
            }
            throw error
        }
    }
    
    func login(credential: String, password: String) async throws -> User {
        state = .loading
        
        do {
            let authTokens = try await authService.login(
                credential: credential,
                password: password
            )
            
            tokenManager.saveTokens(
                accessToken: authTokens.accessToken,
                refreshToken: authTokens.refreshToken
            )
            
            if let user = authTokens.user {
                await MainActor.run {
                    self.currentUser = user
                    self.state = .authenticated(user)
                }
                
                return user
            } else {
                return try await fetchUserWithSavedToken()
            }
        } catch {
            await MainActor.run {
                self.state = .unauthenticated
            }
            throw error
        }
    }
    
    func logout() async {
        if let refreshToken = tokenManager.getRefreshToken() {
            try? await authService.logout(refreshToken: refreshToken)
        }
        
        tokenManager.clearTokens()
        
        await MainActor.run {
            self.currentUser = nil
            self.state = .unauthenticated
        }
    }
    
    func getAccessToken() async throws -> String {
        if tokenManager.isTokenExpired() {
            try await refreshTokenIfNeeded()
        }
        
        if let accessToken = tokenManager.getAccessToken() {
            return accessToken
        }
        
        throw AuthError.sessionExpired
    }
    
    private func refreshTokenIfNeeded() async throws {
        guard let refreshToken = tokenManager.getRefreshToken() else {
            throw AuthError.sessionExpired
        }
        
        do {
            let authTokens = try await authService.refreshToken(refreshToken: refreshToken)
            
            tokenManager.saveTokens(
                accessToken: authTokens.accessToken,
                refreshToken: authTokens.refreshToken
            )
        } catch {
            await logout()
            throw AuthError.sessionExpired
        }
    }
    
    private func checkAuthStatus() async {
        guard let accessToken = tokenManager.getAccessToken() else {
            await MainActor.run {
                state = .unauthenticated
            }
            return
        }
        
        do {
            let user = try await authService.validateSession(accessToken: accessToken)
            
            await MainActor.run {
                self.currentUser = user
                self.state = .authenticated(user)
            }
        } catch {
            do {
                try await refreshTokenIfNeeded()
                
                if let newToken = tokenManager.getAccessToken() {
                    let user = try await authService.validateSession(accessToken: newToken)
                    
                    await MainActor.run {
                        self.currentUser = user
                        self.state = .authenticated(user)
                    }
                } else {
                    await logout()
                }
            } catch {
                await logout()
            }
        }
    }
    
    private func fetchUserWithSavedToken() async throws -> User {
        if let token = tokenManager.getAccessToken() {
            let user = try await authService.validateSession(accessToken: token)
            
            await MainActor.run {
                self.currentUser = user
                self.state = .authenticated(user)
            }
            
            return user
        } else {
            throw AuthError.sessionExpired
        }
    }
} 
