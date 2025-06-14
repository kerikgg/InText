import Foundation
import UIKit

final class ImageUploadService {
    static let shared = ImageUploadService()
    private init() {}

    let imgbbAPIKey = "309dff1c6cf5176f1e84d8b44816fd1c"

    func uploadImageToImgbb(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageConversion", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ошибка конвертации изображения"])))
            return
        }

        let base64String = imageData.base64EncodedString()

        // ВАЖНО: URL-экранируем base64 строку
        guard let encodedBase64 = base64String.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            completion(.failure(NSError(domain: "Encoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ошибка кодирования base64 строки"])))
            return
        }

        var request = URLRequest(url: URL(string: "https://api.imgbb.com/1/upload?key=\(imgbbAPIKey)")!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString = "image=\(encodedBase64)"
        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let dataDict = json?["data"] as? [String: Any],
                   let urlString = dataDict["url"] as? String,
                   let url = URL(string: urlString) {
                    completion(.success(url))
                } else {
                    completion(.failure(NSError(domain: "BadResponse", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}

