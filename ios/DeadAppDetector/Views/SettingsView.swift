import SwiftUI

struct SettingsView: View {
    @ObservedObject private var authService = AuthenticationService.shared
    @Environment(\.dismiss) var dismiss
    @State private var showSignOutAlert = false

    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section {
                    HStack(spacing: Theme.paddingMedium) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Theme.primary)
                            .accessibilityHidden(true)

                        VStack(alignment: .leading, spacing: 4) {
                            if let name = authService.userName {
                                Text(name)
                                    .font(Theme.headlineFont)
                                    .foregroundColor(Theme.primary)
                            } else {
                                Text("Apple User")
                                    .font(Theme.headlineFont)
                                    .foregroundColor(Theme.primary)
                            }

                            if let email = authService.userEmail {
                                Text(email)
                                    .font(Theme.captionFont)
                                    .foregroundColor(Theme.secondary)
                            }

                            Text("Signed in with Apple")
                                .font(Theme.smallFont)
                                .foregroundColor(Theme.secondary)
                        }
                    }
                    .padding(.vertical, Theme.paddingSmall)
                } header: {
                    Text("Profile")
                }

                // App Info Section
                Section {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(Theme.secondary)
                    }

                    HStack {
                        Label("API Status", systemImage: "network")
                        Spacer()
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                            Text("Connected")
                                .foregroundColor(Theme.secondary)
                        }
                    }
                } header: {
                    Text("About")
                }

                // Privacy Section
                Section {
                    Link(destination: URL(string: "https://www.apple.com/legal/privacy/")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }

                    Link(destination: URL(string: "https://www.apple.com/legal/internet-services/terms/site.html")!) {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                } header: {
                    Text("Legal")
                }

                // Sign Out Section
                Section {
                    Button(action: {
                        HapticFeedback.warning.trigger()
                        showSignOutAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Label("Sign Out", systemImage: "arrow.right.square")
                                .foregroundColor(Theme.danger)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        HapticFeedback.light.trigger()
                        dismiss()
                    }
                }
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) {
                    HapticFeedback.light.trigger()
                }
                Button("Sign Out", role: .destructive) {
                    authService.signOut()
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to sign out? Your analysis history will be preserved.")
            }
        }
    }
}

#Preview {
    SettingsView()
}
