import SwiftUI

protocol PigeonAlert: Error {
    var title: String { get }
    var description: String { get }
    var style: AlertStyle { get }
    var details: [String: String]? { get }
}

extension PigeonAlert {
    var details: [String: String]? {
        return nil
    }
}

struct GenericPigeonAlert: PigeonAlert {
    let title: String
    let description: String
    let style: AlertStyle
}

enum AlertStyle {
    case error
    case warning
    case success
    case info
    
    var color: Color {
        switch self {
        case .error: return .red
        case .warning: return .orange
        case .success: return .green
        case .info: return .blue
        }
    }
    
    var iconName: String {
        switch self {
        case .error: return "exclamationmark.triangle.fill"
        case .warning: return "exclamationmark.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var displayDuration: TimeInterval {
        switch self {
        case .error: return 5.0
        case .warning: return 4.0
        case .info: return 3.0
        case .success: return 2.0
        }
    }
    
    var defaultTitle: String {
        switch self {
        case .error: return "Error"
        case .warning: return "Warning"
        case .success: return "Success"
        case .info: return "Information"
        }
    }
}
