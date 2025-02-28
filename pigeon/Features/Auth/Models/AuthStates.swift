import Foundation

enum AuthViewState {
    case login
    case register
}

enum AuthState: Equatable {
    case unauthenticated
    case authenticated(User)
    case loading
}
