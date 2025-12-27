import SwiftUI

struct ResultsView: View {
    let result: AnalysisResult
    @ObservedObject var viewModel: AnalysisViewModel
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.paddingLarge) {
                // Header
                headerSection
                
                // Score card
                ScoreCard(score: result.overallScore, status: result.status)
                
                // Summary
                summarySection
                
                // Categories
                categorySection(title: "Website Signals", category: result.categories.website)
                categorySection(title: "Engineering Signals", category: result.categories.engineering)
                categorySection(title: "Business Signals", category: result.categories.business)
                
                // Actions
                actionButtons
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: Theme.paddingSmall) {
            Text(result.url)
                .font(Theme.headlineFont)
                .foregroundColor(Theme.primary)
            
            Text(formatDate(result.timestamp))
                .font(Theme.captionFont)
                .foregroundColor(Theme.secondary)
            
            if result.cached {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("Cached result")
                }
                .font(Theme.smallFont)
                .foregroundColor(Theme.secondary)
            }
        }
    }
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: Theme.paddingSmall) {
            Text("Summary")
                .font(Theme.headlineFont)
                .foregroundColor(Theme.primary)
            
            Text(result.summary)
                .font(Theme.bodyFont)
                .foregroundColor(Theme.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.paddingMedium)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
    
    private func categorySection(title: String, category: AnalysisResult.Category) -> some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            HStack {
                Text(title)
                    .font(Theme.headlineFont)
                    .foregroundColor(Theme.primary)
                
                Spacer()
                
                Text("\(category.score)/100")
                    .font(Theme.bodyFont)
                    .foregroundColor(Theme.secondary)
            }
            
            VStack(spacing: Theme.paddingSmall) {
                ForEach(category.signals) { signal in
                    SignalRow(signal: signal)
                }
            }
        }
        .padding(Theme.paddingMedium)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
    
    private var actionButtons: some View {
        VStack(spacing: Theme.paddingMedium) {
            Button(action: {
                HapticFeedback.medium.trigger()
                Task {
                    await viewModel.recheckApp()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Recheck App")
                }
                .secondaryButtonStyle()
            }
            .accessibilityLabel("Recheck app")
            .accessibilityHint("Perform a new analysis of this app")
            
            Button(action: {
                HapticFeedback.light.trigger()
                showingShareSheet = true
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Report")
                }
                .primaryButtonStyle()
            }
            .accessibilityLabel("Share report")
            .accessibilityHint("Share this analysis report")
            .sheet(isPresented: $showingShareSheet) {
                ActivityViewController(activityItems: [viewModel.shareReport()])
            }
            
            Button(action: {
                HapticFeedback.selection.trigger()
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    viewModel.reset()
                }
            }) {
                Text("Analyze Another App")
                    .font(Theme.captionFont)
                    .foregroundColor(Theme.secondary)
            }
            .padding(.top, Theme.paddingSmall)
            .accessibilityLabel("Analyze another app")
        }
    }
    
    private func formatDate(_ isoDate: String) -> String {
        return isoDate.formatISO8601Date(style: .medium)
    }
}

// Share sheet wrapper
struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
