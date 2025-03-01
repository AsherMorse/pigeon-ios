import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                Text("Map Screen")
                    .navigationTitle("Map")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            .tag(0)
            
            NavigationStack {
                Text("Letters Screen")
                    .navigationTitle("Letters")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Letters", systemImage: "envelope")
            }
            .tag(1)
            
            NavigationStack {
                Text("Friends Screen")
                    .navigationTitle("Friends")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Friends", systemImage: "person.2")
            }
            .tag(2)
            
            NavigationStack {
                Text("Settings Screen")
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Logout") {
                                Task {
                                    await AuthManager.shared.logout()
                                }
                            }
                        }
                    }
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(3)
        }
    }
}

#Preview {
    MainTabView()
} 
