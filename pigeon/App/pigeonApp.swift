import SwiftUI
import SwiftData

@main
struct PigeonApp: App {
    @State private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Group {
                    if case .authenticated = authManager.state {
                        // TODO: Replace with your main app view
                        Text("Authenticated!")
                            .navigationTitle("Home")
                            .navigationBarTitleDisplayMode(.large)
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button("Logout") {
                                        Task {
                                            await authManager.logout()
                                        }
                                    }
                                }
                            }
                            .foregroundStyle(.blue)
                    } else {
                        AuthView()
                    }
                }
                .showLoading(when: authManager.state == .loading)
            }
        }
    }
}
