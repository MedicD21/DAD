import Foundation
import AuthenticationServices
import SwiftUI

class AuthenticationService: ObservableObject {
    static let shared = AuthenticationService()

    @Published var isAuthenticated: Bool = false
    @Published var userID: String?
    @Published var userEmail: String?
    @Published var userName: String?

    private let userDefaultsKey = "isAuthenticated"
    private let userIDKey = "userID"
    private let userEmailKey = "userEmail"
    private let userNameKey = "userName"

    private init() {
        loadAuthenticationState()
    }

    func loadAuthenticationState() {
        isAuthenticated = UserDefaults.standard.bool(forKey: userDefaultsKey)
        userID = UserDefaults.standard.string(forKey: userIDKey)
        userEmail = UserDefaults.standard.string(forKey: userEmailKey)
        userName = UserDefaults.standard.string(forKey: userNameKey)
    }

    func handleSignInWithApple(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                userID = appleIDCredential.user
                userEmail = appleIDCredential.email
                userName = appleIDCredential.fullName?.givenName

                // Save authentication state
                UserDefaults.standard.set(true, forKey: userDefaultsKey)
                UserDefaults.standard.set(userID, forKey: userIDKey)
                UserDefaults.standard.set(userEmail, forKey: userEmailKey)
                UserDefaults.standard.set(userName, forKey: userNameKey)

                isAuthenticated = true
                HapticFeedback.success.trigger()
            }
        case .failure(let error):
            print("Sign in with Apple failed: \(error.localizedDescription)")
            HapticFeedback.error.trigger()
        }
    }

    func signOut() {
        UserDefaults.standard.set(false, forKey: userDefaultsKey)
        UserDefaults.standard.removeObject(forKey: userIDKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        UserDefaults.standard.removeObject(forKey: userNameKey)

        isAuthenticated = false
        userID = nil
        userEmail = nil
        userName = nil

        HapticFeedback.light.trigger()
    }
}

// MARK: - Sign in with Apple Button Representable

struct SignInWithAppleButton: UIViewRepresentable {
    var onCompletion: (Result<ASAuthorization, Error>) -> Void

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.cornerRadius = Theme.cornerRadius
        button.addTarget(context.coordinator, action: #selector(Coordinator.handleTap), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        let parent: SignInWithAppleButton

        init(_ parent: SignInWithAppleButton) {
            self.parent = parent
        }

        @objc func handleTap() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            parent.onCompletion(.success(authorization))
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            parent.onCompletion(.failure(error))
        }

        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = scene.windows.first else {
                return UIWindow()
            }
            return window
        }
    }
}
