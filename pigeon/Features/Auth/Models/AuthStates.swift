import Foundation

enum AuthViewState {
    case login
    case register
}

enum AuthFormState: Equatable {
    case idle
    case loading
} 
