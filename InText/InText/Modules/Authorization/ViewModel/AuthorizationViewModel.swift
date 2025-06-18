import Foundation
import Combine
import SwiftUI

final class AuthorizationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    @Published var loginError: String?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var loginSuccess = false

    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var canSubmit: Bool {
        !email.isEmpty && !password.isEmpty
    }

    private let authService = AuthService.shared

    func loginUser() {
        guard canSubmit else { return }

        isLoading = true
        loginError = nil

        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.isLoggedIn = true
                    self?.loginSuccess = true
                case .failure(let error):
                    self?.loginError = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
}
