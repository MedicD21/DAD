import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: AnalysisViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.history.isEmpty {
                    Text("No analysis history")
                        .foregroundColor(Theme.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(Theme.paddingLarge)
                } else {
                    ForEach(viewModel.history) { result in
                        HistoryRow(result: result)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.currentResult = result
                                dismiss()
                            }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            viewModel.deleteHistoryItem(id: viewModel.history[index].id)
                        }
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewModel.history.isEmpty {
                        Button("Clear") {
                            viewModel.clearHistory()
                        }
                        .foregroundColor(Theme.danger)
                    }
                }
            }
        }
    }
}

struct HistoryRow: View {
    let result: AnalysisResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingSmall) {
            HStack {
                Text(result.url)
                    .font(Theme.bodyFont)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Spacer()
                
                Text("\(result.overallScore)")
                    .font(Theme.headlineFont)
                    .foregroundColor(statusColor)
            }
            
            HStack {
                Text(formatDate(result.timestamp))
                    .font(Theme.captionFont)
                    .foregroundColor(Theme.secondary)
                
                Spacer()
                
                Text(result.status.displayName)
                    .font(Theme.smallFont)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor)
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, Theme.paddingSmall)
    }
    
    private var statusColor: Color {
        switch result.status {
        case .healthy:
            return Theme.success
        case .caution:
            return Theme.warning
        case .risk:
            return Theme.danger
        }
    }
    
    private func formatDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: isoDate) else { return isoDate }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .short
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
}
