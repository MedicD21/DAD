import SwiftUI

struct StatusBadge: View {
    let status: AnalysisResult.Status
    
    var body: some View {
        Text(status.displayName)
            .font(Theme.bodyFont)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, Theme.paddingMedium)
            .padding(.vertical, Theme.paddingSmall)
            .background(statusColor)
            .cornerRadius(Theme.cornerRadiusSmall)
    }
    
    private var statusColor: Color {
        switch status {
        case .healthy:
            return Theme.success
        case .caution:
            return Theme.warning
        case .risk:
            return Theme.danger
        }
    }
}
