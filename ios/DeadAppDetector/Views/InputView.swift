import SwiftUI

struct InputView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                VStack(spacing: Theme.paddingLarge) {
                    if let result = viewModel.currentResult {
                        ResultsView(result: result, viewModel: viewModel)
                    } else {
                        inputContent
                    }
                }
                .padding(Theme.paddingLarge)
                
                if viewModel.isLoading {
                    LoadingOverlay()
                }
            }
            .navigationTitle("Dead App Detector")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showingHistory = true }) {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingHistory) {
                HistoryView(viewModel: viewModel)
            }
        }
    }
    
    private var inputContent: some View {
        VStack(spacing: Theme.paddingLarge) {
            Spacer()
            
            VStack(spacing: Theme.paddingMedium) {
                Image(systemName: "app.badge.checkmark")
                    .font(.system(size: 60))
                    .foregroundColor(Theme.primary)
                
                Text("Dead App Detector")
                    .font(Theme.titleFont)
                    .foregroundColor(Theme.primary)
                
                Text("Detect if a SaaS product is still maintained")
                    .font(Theme.bodyFont)
                    .foregroundColor(Theme.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            VStack(spacing: Theme.paddingMedium) {
                TextField("Enter website URL", text: $viewModel.urlInput)
                    .textFieldStyle(.plain)
                    .padding(Theme.paddingMedium)
                    .background(Theme.cardBackground)
                    .cornerRadius(Theme.cornerRadius)
                    .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)
                
                if let error = viewModel.error {
                    Text(error)
                        .font(Theme.captionFont)
                        .foregroundColor(Theme.danger)
                }
                
                Button(action: {
                    Task {
                        await viewModel.analyzeApp()
                    }
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Analyze App")
                    }
                    .font(Theme.headlineFont)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(Theme.paddingMedium)
                    .background(Theme.primary)
                    .cornerRadius(Theme.cornerRadius)
                }
                .disabled(viewModel.urlInput.isEmpty)
                .opacity(viewModel.urlInput.isEmpty ? 0.6 : 1.0)
            }
            
            Spacer()
        }
    }
}

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: Theme.paddingMedium) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                
                Text("Analyzing app...")
                    .font(Theme.bodyFont)
                    .foregroundColor(.white)
            }
            .padding(Theme.paddingLarge)
            .background(Theme.primary)
            .cornerRadius(Theme.cornerRadius)
        }
    }
}
