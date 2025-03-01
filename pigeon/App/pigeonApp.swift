import SwiftUI
import SwiftData

@main
struct PigeonApp: App {
    @State private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if case .authenticated = authManager.state {
                    MainTabView()
                } else {
                    NavigationStack {
                        AuthView()
                    }
                }
            }
            .showLoading(when: authManager.state == .loading)
            .withAlertOverlay()
        }
    }
}
