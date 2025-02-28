import SwiftUI
import SwiftData

@main
struct PigeonApp: App {
    @State private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Group {
                    switch authManager.state {
                    case .authenticated:
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
                    case .unauthenticated:
                        AuthView()
                    case .loading:
                        ProgressView("Loading...")
                    }
                }
            }
        }
    }
}
