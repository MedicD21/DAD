import SwiftUI

@main
struct DeadAppDetectorApp: App {
    @StateObject private var authService = AuthenticationService.shared

    var body: some Scene {
        WindowGroup {
            Group {
                if authService.isAuthenticated {
                    InputView()
                        .transition(.opacity.combined(with: .scale))
                } else {
                    SignInView()
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .animation(.easeInOut, value: authService.isAuthenticated)
        }
    }
}
