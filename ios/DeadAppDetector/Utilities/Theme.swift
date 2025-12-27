import SwiftUI

struct Theme {
    // Colors
    static let primary = Color(red: 0.2, green: 0.2, blue: 0.25)
    static let secondary = Color(red: 0.4, green: 0.4, blue: 0.45)
    static let background = Color(red: 0.98, green: 0.98, blue: 0.99)
    static let cardBackground = Color.white
    
    static let success = Color.green
    static let warning = Color.orange
    static let danger = Color.red
    static let neutral = Color.gray
    
    // Typography
    static let titleFont = Font.system(size: 28, weight: .bold)
    static let headlineFont = Font.system(size: 20, weight: .semibold)
    static let bodyFont = Font.system(size: 16, weight: .regular)
    static let captionFont = Font.system(size: 14, weight: .regular)
    static let smallFont = Font.system(size: 12, weight: .regular)
    
    // Spacing
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    
    // Corner radius
    static let cornerRadius: CGFloat = 12
    static let cornerRadiusSmall: CGFloat = 8
}
