//
//  AuthService.swift
//  InText
//
//  Created by kerik on 08.05.2025.
//

import Foundation
import FirebaseAuth

final class AuthService {
    private let auth: Auth
    static let shared = AuthService()

    private init() {
        auth = Auth.auth()
    }

    func register(email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
        }

    }

    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось войти."])))
            }
        }
    }
}
