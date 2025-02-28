import SwiftUI
import SwiftData

@main
struct PigeonApp: App {
    @State private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
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
                    
                    if case .loading = authManager.state {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        ProgressView("Loading...")
                            .padding()
                            .background(.thickMaterial)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
