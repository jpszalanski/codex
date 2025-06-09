import Foundation
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

/// Helper responsible for handling Google authentication.
/// The implementation uses GoogleSignIn SDK and exposes simple
/// callbacks to SwiftUI views.
class GoogleSignInHelper: ObservableObject {
    static let shared = GoogleSignInHelper()
    private init() {}

    /// Attempts to sign in the user with Google and invokes the
    /// completion handler with `true` on success.
    func signIn(presenting viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_CLIENT_ID") as? String else {
            completion(false)
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let _ = result, error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    /// Signs the user out of Google.
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
