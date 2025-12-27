import SwiftUI
import Foundation

// MARK: - Date Formatting Utilities

extension String {
    func formatISO8601Date(style: DateFormatter.Style = .medium) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: self) else { return self }

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = style
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
}

// MARK: - Haptic Feedback

enum HapticFeedback {
    case success
    case warning
    case error
    case light
    case medium
    case heavy
    case selection

    func trigger() {
        switch self {
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}

// MARK: - View Extensions for Animations

extension View {
    func animatedAppearance(delay: Double = 0) -> some View {
        self
            .transition(.asymmetric(
                insertion: .scale.combined(with: .opacity),
                removal: .opacity
            ))
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay), value: UUID())
    }

    func shimmer(isActive: Bool = true) -> some View {
        self.modifier(ShimmerModifier(isActive: isActive))
    }
}

// MARK: - Shimmer Effect for Loading States

struct ShimmerModifier: ViewModifier {
    let isActive: Bool
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        Color.white.opacity(isActive ? 0.3 : 0),
                        .clear
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                if isActive {
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        phase = 300
                    }
                }
            }
    }
}

// MARK: - URL Validation

extension String {
    var isValidURL: Bool {
        if let url = URL(string: self),
           let scheme = url.scheme,
           scheme == "http" || scheme == "https" {
            return true
        }
        return false
    }

    var normalizedURL: String {
        var normalized = self.trimmingCharacters(in: .whitespaces)
        if !normalized.hasPrefix("http://") && !normalized.hasPrefix("https://") {
            normalized = "https://\(normalized)"
        }
        return normalized
    }
}
