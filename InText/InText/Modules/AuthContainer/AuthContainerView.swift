import SwiftUI

struct AuthContainerView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var showLogin = false

    var body: some View {
        NavigationView {
            if isLoggedIn {
                MainTabView()
            } else {
                if showLogin {
                    AuthorizationView(showLogin: $showLogin)
                } else {
                    RegistrationView(showLogin: $showLogin)
                }
            }
        }
    }
}
