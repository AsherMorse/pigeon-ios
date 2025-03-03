import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: String
    let username: String
    let email: String
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
} 
