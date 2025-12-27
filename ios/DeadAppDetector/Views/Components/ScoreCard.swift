import SwiftUI

struct ScoreCard: View {
    let score: Int
    let status: AnalysisResult.Status
    
    var body: some View {
        VStack(spacing: Theme.paddingMedium) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 12)
                    .opacity(0.2)
                    .foregroundColor(statusColor)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(Double(score) / 100.0, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .foregroundColor(statusColor)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeInOut(duration: 1.0), value: score)
                
                VStack {
                    Text("\(score)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Theme.primary)
                    
                    Text("/ 100")
                        .font(Theme.captionFont)
                        .foregroundColor(Theme.secondary)
                }
            }
            .frame(width: 160, height: 160)
            
            StatusBadge(status: status)
        }
        .padding(Theme.paddingLarge)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
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
