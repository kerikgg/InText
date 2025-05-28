//
//  RegistrationViewModel.swift
//  InText
//
//  Created by kerik on 09.05.2025.
//

import Foundation
import Combine

final class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var canSubmit = false

    @Published private var isValidEmail = false
    @Published private var isValidPassword = false
    @Published private var isValidName = false

    @Published var registrationError: String?
    @Published var isLoading = false
    @Published var registrationSuccess = false
    @Published var showAlert = false

    private let authService = AuthService.shared
    
    var emailPrompt: String? {
        if isValidEmail == true || email.isEmpty {
            return nil
        } else {
            return "Введите валидную почту. Пример: test@test.com"
        }
    }

    var passwordPrompt: String? {
        if isValidPassword == true || password.isEmpty {
            return nil
        } else {
            return "Пароль должен содержать не менее 6 символов."
        }
    }

    var namePrompt: String? {
        if isValidName == true || name.isEmpty {
            return nil
        } else {
            return "Имя должно начинаться с заглавной буквы."
        }
    }

    private var cancellableSet: Set<AnyCancellable> = []
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", Regex.email.rawValue)

    init() {

        validateName()
        validateEmail()
        validatePassword()

        Publishers.CombineLatest3($isValidEmail, $isValidPassword, $isValidName)
            .map { first, second, third in
                return (first && second && third)
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellableSet)
    }

    func registerUser() {
        guard canSubmit else { return }

        isLoading = true
        registrationError = nil

        authService.register(email: email, password: password, name: name) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.registrationSuccess = true
                case .failure(let error):
                    self?.registrationError = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }

    private func validateName() {
        $name
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { name in
                return name.first?.isUppercase ?? false
            }
            .assign(to: \.isValidName, on: self)
            .store(in: &cancellableSet)
    }

    private func validateEmail() {
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { email in
                return self.emailPredicate.evaluate(with: email)
            }
            .assign(to: \.isValidEmail, on: self)
            .store(in: &cancellableSet)
    }

    private func validatePassword() {
        $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { password in
                return password.count >= 6
            }
            .assign(to: \.isValidPassword, on: self)
            .store(in: &cancellableSet)
    }
}
