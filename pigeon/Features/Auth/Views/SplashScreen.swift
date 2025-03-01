import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            Image(.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text("Pigeon")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    SplashScreen()
}
