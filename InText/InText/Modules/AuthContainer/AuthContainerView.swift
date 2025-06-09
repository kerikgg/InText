//
//  AuthContainerView.swift
//  InText
//
//  Created by kerik on 28.05.2025.
//

import SwiftUI

struct AuthContainerView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var showLogin = false

    var body: some View {
        NavigationStack {
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
