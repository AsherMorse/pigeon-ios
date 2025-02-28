import Foundation

enum AuthViewState {
    case login
    case register
}

enum AuthState {
    case unauthenticated
    case authenticated(User)
    case loading
}
