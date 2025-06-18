//import Foundation
//
//final class LemmatizerService {
//    static let shared = LemmatizerService()
//
//    private init() {}
//
//    func lemmatize(text: String, completion: @escaping ([String]) -> Void) {
//        guard let url = URL(string: "http://127.0.0.1:5000/lemmatize") else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let body = ["text": text]
//        guard let httpBody = try? JSONEncoder().encode(body) else {
//            print("Failed to encode JSON")
//            return
//        }
//        request.httpBody = httpBody
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data else {
//                print("No data: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            do {
//                let result = try JSONDecoder().decode(LemmatizerResponse.self, from: data)
//                DispatchQueue.main.async {
//                    completion(result.lemmas)
//                }
//            } catch {
//                print("Decoding error: \(error.localizedDescription)")
//            }
//        }.resume()
//    }
//}

import Foundation

final class LemmatizerService {
    static let shared = LemmatizerService()
    private let baseURL = "http://37.233.81.128"

    func lemmatize(text: String, completion: @escaping ([String]) -> Void) {
//        guard let url = URL(string: "http://127.0.0.1:5000/lemmatize") else {
        guard let url = URL(string: "\(baseURL)/lemmatize") else {
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["text": text]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data, error == nil else {
                print("Ошибка: \(error?.localizedDescription ?? "нет данных")")
                completion([])
                return
            }

            if let result = try? JSONDecoder().decode([String: [String]].self, from: data),
               let lemmas = result["lemmas"] {
                completion(lemmas)
            } else {
                completion([])
            }
        }.resume()
    }

    /// Частотность ключевых слов (на основе исходного текста и списка keywords)
    func keywordFrequencies(in text: String, keywords: [String], completion: @escaping ([KeywordFrequency]) -> Void) {
        lemmatize(text: text) { lemmas in
            var counts: [String: Int] = [:]

            for keyword in keywords {
                let keywordLower = keyword.lowercased()
                let frequency = lemmas.filter { $0 == keywordLower }.count
                if frequency > 0 {
                    counts[keyword] = frequency
                }
            }

            let result = counts
                .map { KeywordFrequency(keyword: $0.key, count: $0.value) }
                .sorted { $0.count > $1.count }

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}


struct LemmatizerResponse: Decodable {
    let lemmas: [String]
}

