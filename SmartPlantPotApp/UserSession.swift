import Foundation

/// Global session object that stores the authenticated user's information
/// and linked devices.
class UserSession: ObservableObject {
    @Published var user: User

    init(user: User) {
        self.user = user
    }
}
