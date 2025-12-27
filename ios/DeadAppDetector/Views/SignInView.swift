import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @ObservedObject var authService = AuthenticationService.shared
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Theme.primary.opacity(0.1),
                    Theme.background
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: Theme.paddingXLarge) {
                Spacer()

                // App Icon and Title
                VStack(spacing: Theme.paddingLarge) {
                    Image(systemName: "app.badge.checkmark")
                        .font(.system(size: 100))
                        .foregroundColor(Theme.primary)
                        .symbolRenderingMode(.hierarchical)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .accessibilityHidden(true)

                    VStack(spacing: Theme.paddingSmall) {
                        Text("Dead App Detector")
                            .font(Theme.titleFont)
                            .foregroundColor(Theme.primary)
                            .opacity(isAnimating ? 1.0 : 0.0)
                            .offset(y: isAnimating ? 0 : 20)
                            .accessibilityAddTraits(.isHeader)

                        Text("Know if your SaaS is thriving or dying")
                            .font(Theme.bodyFont)
                            .foregroundColor(Theme.secondary)
                            .multilineTextAlignment(.center)
                            .opacity(isAnimating ? 1.0 : 0.0)
                            .offset(y: isAnimating ? 0 : 20)
                    }
                }

                Spacer()

                // Features
                VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                    FeatureRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Comprehensive Analysis",
                        description: "Analyzes website, engineering, and business signals"
                    )
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(x: isAnimating ? 0 : -30)

                    FeatureRow(
                        icon: "clock.arrow.circlepath",
                        title: "Track History",
                        description: "Keep track of all your analyzed apps"
                    )
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(x: isAnimating ? 0 : -30)

                    FeatureRow(
                        icon: "square.and.arrow.up",
                        title: "Share Reports",
                        description: "Export and share detailed analysis reports"
                    )
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(x: isAnimating ? 0 : -30)
                }
                .padding(.horizontal, Theme.paddingLarge)

                Spacer()

                // Sign in Button
                VStack(spacing: Theme.paddingMedium) {
                    SignInWithAppleButton { result in
                        authService.handleSignInWithApple(result: result)
                    }
                    .frame(height: 50)
                    .padding(.horizontal, Theme.paddingLarge)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 30)
                    .accessibilityLabel("Sign in with Apple")
                    .accessibilityHint("Authenticate to use Dead App Detector")

                    Text("We use Sign in with Apple to keep your data secure and private")
                        .font(Theme.captionFont)
                        .foregroundColor(Theme.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.paddingXLarge)
                        .opacity(isAnimating ? 0.7 : 0.0)
                }
                .padding(.bottom, Theme.paddingXLarge)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                isAnimating = true
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: Theme.paddingMedium) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Theme.primary)
                .frame(width: 40)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Theme.bodyFont)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.primary)

                Text(description)
                    .font(Theme.captionFont)
                    .foregroundColor(Theme.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    SignInView()
}
