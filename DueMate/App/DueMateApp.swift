import SwiftUI

@main
struct DueMateApp: App {
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showLaunchScreen = false
                            }
                        }
                    }
            } else {
                MainTabView()
            }
        }
    }
}
