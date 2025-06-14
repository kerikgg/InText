import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @Published var isDarkMode = false
    @Published var showDeleteAlert = false
    @Published var user: UserModel?

    private let authService = AuthService.shared

    init() {
        loadUser()
    }

    func loadUser() {
        guard let currentUser = authService.currentUser else { return }

        authService.fetchUserProfile(uid: currentUser.uid) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userModel):
                    self?.user = userModel
                case .failure(let error):
                    print("Ошибка загрузки профиля: \(error.localizedDescription)")
                }
            }
        }
    }

    func updatePhotoURL(url: URL) {
        guard let uid = authService.currentUser?.uid else { return }

        authService.updatePhotoURL(for: uid, url: url) { [weak self] error in
            if error == nil {
                DispatchQueue.main.async {
                    self?.user?.photoURL = url
                }
            }
        }
    }

    func logout() {
        do {
            try authService.logout()
            isLoggedIn = false
        } catch {
            print("Ошибка выхода: \(error.localizedDescription)")
        }
    }

    func deleteAccount() {
        authService.deleteAccount { [weak self] error in
            if let error = error {
                print("Ошибка удаления аккаунта: \(error.localizedDescription)")
            } else {
                self?.isLoggedIn = false
            }
        }
    }
}

