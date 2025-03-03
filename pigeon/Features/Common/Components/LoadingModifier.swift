import SwiftUI

struct LoadingModifier: ViewModifier {
    let isLoading: Bool
    let message: String?
    
    init(isLoading: Bool, message: String? = "Loading...") {
        self.isLoading = isLoading
        self.message = message
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
            
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                if let message = message {
                    ProgressView(message)
                        .padding()
                        .background(.thickMaterial)
                        .cornerRadius(10)
                } else {
                    ProgressView()
                        .padding()
                        .background(.thickMaterial)
                        .cornerRadius(10)
                }
            }
        }
    }
}

extension View {
    func showLoading(when isLoading: Bool, message: String? = "Loading...") -> some View {
        modifier(LoadingModifier(isLoading: isLoading, message: message))
    }
}

#Preview {
    VStack {
        Text("Content behind loading screen")
            .padding()
    }
    .frame(width: 300, height: 300)
    .background(Color.blue.opacity(0.2))
    .showLoading(when: true)
} 
