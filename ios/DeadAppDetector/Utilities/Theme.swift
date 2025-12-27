import SwiftUI

struct Theme {
    // MARK: - Colors (Dark Mode Adaptive)

    static let primary = Color("PrimaryColor", bundle: nil)
        .fallback(light: Color(red: 0.2, green: 0.2, blue: 0.25),
                  dark: Color(red: 0.9, green: 0.9, blue: 0.95))

    static let secondary = Color("SecondaryColor", bundle: nil)
        .fallback(light: Color(red: 0.4, green: 0.4, blue: 0.45),
                  dark: Color(red: 0.6, green: 0.6, blue: 0.65))

    static let background = Color("BackgroundColor", bundle: nil)
        .fallback(light: Color(red: 0.98, green: 0.98, blue: 0.99),
                  dark: Color(red: 0.08, green: 0.08, blue: 0.09))

    static let cardBackground = Color("CardBackground", bundle: nil)
        .fallback(light: .white, dark: Color(red: 0.15, green: 0.15, blue: 0.17))

    // Status Colors
    static let success = Color.green
    static let warning = Color.orange
    static let danger = Color.red
    static let neutral = Color.gray

    // MARK: - Typography

    static let titleFont = Font.system(size: 32, weight: .bold, design: .rounded)
    static let headlineFont = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let bodyFont = Font.system(size: 16, weight: .regular, design: .default)
    static let captionFont = Font.system(size: 14, weight: .regular, design: .default)
    static let smallFont = Font.system(size: 12, weight: .regular, design: .default)

    // MARK: - Spacing

    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let paddingXLarge: CGFloat = 32

    // MARK: - Corner Radius

    static let cornerRadius: CGFloat = 16
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusLarge: CGFloat = 24

    // MARK: - Shadows

    static func cardShadow(isElevated: Bool = false) -> some View {
        Color.clear.shadow(
            color: Color.black.opacity(isElevated ? 0.12 : 0.06),
            radius: isElevated ? 12 : 6,
            x: 0,
            y: isElevated ? 6 : 2
        )
    }
}

// MARK: - Color Extension for Fallback

extension Color {
    func fallback(light: Color, dark: Color) -> Color {
        return Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

// MARK: - View Modifiers

extension View {
    func cardStyle(elevated: Bool = false) -> some View {
        self
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            .shadow(
                color: Color.black.opacity(elevated ? 0.12 : 0.06),
                radius: elevated ? 12 : 6,
                x: 0,
                y: elevated ? 6 : 2
            )
    }

    func primaryButtonStyle() -> some View {
        self
            .font(Theme.headlineFont)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(Theme.paddingMedium)
            .background(Theme.primary)
            .cornerRadius(Theme.cornerRadius)
    }

    func secondaryButtonStyle() -> some View {
        self
            .font(Theme.bodyFont)
            .foregroundColor(Theme.primary)
            .frame(maxWidth: .infinity)
            .padding(Theme.paddingMedium)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(Theme.primary, lineWidth: 2)
            )
    }
}
