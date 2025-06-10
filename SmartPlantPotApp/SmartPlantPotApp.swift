import SwiftUI

@main
struct SmartPlantPotApp: App {
    @StateObject private var session = UserSession(user: User(email: "", password: "", locations: [], devices: []))

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(session)
        }
    }
}
