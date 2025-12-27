import SwiftUI

struct SignalRow: View {
    let signal: Signal
    
    var body: some View {
        HStack(alignment: .top, spacing: Theme.paddingMedium) {
            Image(systemName: statusIcon)
                .foregroundColor(statusColor)
                .font(.system(size: 20))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(signal.name)
                        .font(Theme.bodyFont)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.primary)
                    
                    Spacer()
                    
                    Text(signal.value)
                        .font(Theme.captionFont)
                        .foregroundColor(Theme.secondary)
                }
                
                Text(signal.explanation)
                    .font(Theme.captionFont)
                    .foregroundColor(Theme.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(Theme.paddingMedium)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(Theme.cornerRadiusSmall)
    }
    
    private var statusIcon: String {
        switch signal.status {
        case .healthy:
            return "checkmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .risk:
            return "xmark.circle.fill"
        case .unknown:
            return "questionmark.circle.fill"
        }
    }
    
    private var statusColor: Color {
        switch signal.status {
        case .healthy:
            return Theme.success
        case .warning:
            return Theme.warning
        case .risk:
            return Theme.danger
        case .unknown:
            return Theme.neutral
        }
    }
}
