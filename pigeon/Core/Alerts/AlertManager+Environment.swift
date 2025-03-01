import SwiftUI

private struct AlertManagerKey: EnvironmentKey {
    static let defaultValue = AlertManager.shared
}

extension EnvironmentValues {
    var alertManager: AlertManager {
        get { self[AlertManagerKey.self] }
        set { self[AlertManagerKey.self] = newValue }
    }
}

struct AlertOverlayModifier: ViewModifier {
    @ObservedObject private var manager: AlertManager
    
    init(manager: AlertManager = .shared) {
        self.manager = manager
    }
    
    func body(content: Content) -> some View {
        content.overlay(alignment: .top) {
            ZStack {
                if manager.isPresenting, let alert = manager.currentAlert {
                    PigeonAlertView(alert: alert) {
                        manager.dismiss()
                    }
                    .padding()
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: manager.isPresenting)
        }
    }
}

extension View {
    func withAlertOverlay(manager: AlertManager = .shared) -> some View {
        modifier(AlertOverlayModifier(manager: manager))
    }
} 
