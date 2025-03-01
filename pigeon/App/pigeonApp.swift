import SwiftUI
import SwiftData

@main
struct PigeonApp: App {
    @State private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isCheckingInitialAuth {
                    SplashScreen()
                        .transition(.opacity)
                } else if case .authenticated = authManager.state {
                    MainTabView()
                        .transition(.opacity)
                } else {
                    NavigationStack {
                        AuthView()
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: authManager.isCheckingInitialAuth)
            .animation(.easeInOut, value: authManager.state)
            .showLoading(when: authManager.state == .loading)
            .withAlertOverlay()
        }
    }
}
