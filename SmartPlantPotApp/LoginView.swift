import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var session: UserSession
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        if isLoggedIn {
            DashboardView()
                .environmentObject(session)
        } else {
            VStack {
                Text("Smart Plant Pot").font(.largeTitle)
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Login") {
                    // TODO: Implement real authentication
                    session.user.email = email
                    isLoggedIn = true
                }
                .padding()
                Button("Sign Up") {
                    // TODO: Implement sign up flow
                }.padding()

                GoogleSignInButton {
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let root = scene.windows.first?.rootViewController {
                        GoogleSignInHelper.shared.signIn(presenting: root) { success in
                            isLoggedIn = success
                        }
                    }
                }
                .padding()
            }.padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserSession(user: User(email: "", password: "", locations: [], devices: [])))
    }
}
