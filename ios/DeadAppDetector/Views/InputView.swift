import SwiftUI

struct InputView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    @ObservedObject private var authService = AuthenticationService.shared
    @State private var showError = false
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()

                VStack(spacing: Theme.paddingLarge) {
                    if let result = viewModel.currentResult {
                        ResultsView(result: result, viewModel: viewModel)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    } else {
                        inputContent
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                    }
                }
                .padding(Theme.paddingLarge)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.currentResult)

                if viewModel.isLoading {
                    LoadingOverlay()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .navigationTitle("Dead App Detector")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        HapticFeedback.light.trigger()
                        showSettings = true
                    }) {
                        Image(systemName: "person.circle")
                            .accessibilityLabel("Profile and settings")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        HapticFeedback.light.trigger()
                        viewModel.showingHistory = true
                    }) {
                        Image(systemName: "clock.arrow.circlepath")
                            .accessibilityLabel("View history")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingHistory) {
                HistoryView(viewModel: viewModel)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .alert("Error", isPresented: $showError, presenting: viewModel.error) { _ in
                Button("OK") {
                    HapticFeedback.light.trigger()
                }
            } message: { error in
                Text(error)
            }
            .onChange(of: viewModel.error) { error in
                if error != nil {
                    HapticFeedback.error.trigger()
                    showError = true
                }
            }
        }
    }

    private var inputContent: some View {
        VStack(spacing: Theme.paddingLarge) {
            Spacer()

            VStack(spacing: Theme.paddingMedium) {
                Image(systemName: "app.badge.checkmark")
                    .font(.system(size: 70))
                    .foregroundColor(Theme.primary)
                    .symbolRenderingMode(.hierarchical)
                    .scaleEffect(1.0)
                    .accessibilityHidden(true)

                Text("Dead App Detector")
                    .font(Theme.titleFont)
                    .foregroundColor(Theme.primary)
                    .accessibilityAddTraits(.isHeader)

                Text("Analyze any SaaS product to see if it's actively maintained")
                    .font(Theme.bodyFont)
                    .foregroundColor(Theme.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.paddingMedium)
            }

            Spacer()

            VStack(spacing: Theme.paddingMedium) {
                HStack {
                    Image(systemName: "link")
                        .foregroundColor(Theme.secondary)
                        .accessibilityHidden(true)

                    TextField("Enter website URL (e.g., stripe.com)", text: $viewModel.urlInput)
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)
                        .submitLabel(.go)
                        .onSubmit {
                            if !viewModel.urlInput.isEmpty {
                                Task {
                                    await viewModel.analyzeApp()
                                }
                            }
                        }
                        .accessibilityLabel("Website URL")
                        .accessibilityHint("Enter the URL of the app you want to analyze")
                }
                .padding(Theme.paddingMedium)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                        .stroke(viewModel.urlInput.isEmpty ? Color.clear : Theme.primary.opacity(0.3), lineWidth: 2)
                )
                .animation(.easeInOut(duration: 0.2), value: viewModel.urlInput.isEmpty)

                Button(action: {
                    HapticFeedback.medium.trigger()
                    Task {
                        await viewModel.analyzeApp()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                        Text("Analyze App")
                    }
                    .primaryButtonStyle()
                }
                .disabled(viewModel.urlInput.isEmpty)
                .opacity(viewModel.urlInput.isEmpty ? 0.5 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: viewModel.urlInput.isEmpty)
                .accessibilityLabel("Analyze app")
                .accessibilityHint("Start analyzing the entered URL")
            }

            Spacer()
        }
    }
}

struct LoadingOverlay: View {
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { }

            VStack(spacing: Theme.paddingMedium) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 4)
                        .opacity(0.2)
                        .foregroundColor(.white)

                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: rotation))
                }
                .frame(width: 50, height: 50)
                .onAppear {
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }

                Text("Analyzing app...")
                    .font(Theme.bodyFont)
                    .foregroundColor(.white)

                Text("This may take up to 60 seconds")
                    .font(Theme.captionFont)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(Theme.paddingXLarge)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                    .fill(Theme.primary)
                    .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
            )
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Analyzing app")
    }
}
