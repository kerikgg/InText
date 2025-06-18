import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthService {
    private let auth: Auth
    static let shared = AuthService()

    private init() {
        auth = Auth.auth()
    }

    var currentUser: User? {
        auth.currentUser
    }

    func register(email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                completion(.failure(NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пользователь не создан."])))
                return
            }

            // Сохраняем имя и email в Firestore
            self.saveUserProfile(uid: user.uid, name: name, email: email)

            // Устанавливаем displayName в Firebase Auth
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(user))
                }
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

    func logout() throws {
        try auth.signOut()
    }

    func deleteAccount(completion: @escaping (Error?) -> Void) {
        auth.currentUser?.delete(completion: completion)
    }
}

extension AuthService {
    private var db: Firestore {
        Firestore.firestore()
    }

    func saveUserProfile(uid: String, name: String, email: String, completion: ((Error?) -> Void)? = nil) {
        let data: [String: Any] = [
            "name": name,
            "email": email,
            "createdAt": Timestamp()
        ]

        db.collection("users").document(uid).setData(data, merge: true) { error in
            completion?(error)
        }
    }

    func fetchUserProfile(uid: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = snapshot?.data() else {
                completion(.failure(NSError(domain: "AuthService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Данные пользователя не найдены."])))
                return
            }

            let user = UserModel(
                id: uid,
                name: data["name"] as? String ?? "Без имени",
                email: data["email"] as? String ?? "Без почты",
                photoURL: URL(string: data["photoURL"] as? String ?? "")
            )

            completion(.success(user))
        }
    }

    func updatePhotoURL(for uid: String, url: URL, completion: ((Error?) -> Void)? = nil) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData([
            "photoURL": url.absoluteString
        ]) { error in
            completion?(error)
        }
    }
}
