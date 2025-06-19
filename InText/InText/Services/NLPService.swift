//import Foundation
//
//final class NLPService {
//    private let apiKey = Secrets.openAIKey
//
//    func analyze(text: String, completion: @escaping (String?, [String]?) -> Void) {
//        let prompt = "Резюме и ключевые слова для текста в JSON: { \"summary\": \"...\", \"keywords\": [\"...\", \"...\"] }. Текст: \(text)"
//
//        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let body: [String: Any] = [
//            "model": "gpt-3.5-turbo",
//            "messages": [
//                ["role": "user", "content": prompt]
//            ],
//            "temperature": 0.7
//        ]
//
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            guard
//                let data = data,
//                let result = try? JSONDecoder().decode(OpenAIResponse.self, from: data),
//                let jsonString = result.choices.first?.message.content,
//                let jsonData = jsonString.data(using: .utf8),
//                let parsed = try? JSONDecoder().decode(AnalysisResult.self, from: jsonData)
//            else {
//                completion(nil, nil)
//                return
//            }
//
//            completion(parsed.summary, parsed.keywords)
//        }.resume()
//    }
//}
//
//// MARK: - Models
//
//struct OpenAIResponse: Decodable {
//    struct Choice: Decodable {
//        let message: Message
//    }
//    struct Message: Decodable {
//        let content: String
//    }
//    let choices: [Choice]
//}
//
//struct AnalysisResult: Decodable {
//    let summary: String
//    let keywords: [String]
//}
//

import Foundation

final class NLPService {
    private let apiKey = Secrets.openAIKey
    static let shared = NLPService()
    private init() {}

    func analyze(text: String, completion: @escaping (Result<(summary: String, keywords: [String]), Error>) -> Void) {
        // Формируем prompt
        let prompt = "Резюме и ключевые слова для текста в JSON: { \"summary\": \"...\", \"keywords\": [\"...\", \"...\"] }. Текст: \(text)"

        // Подготовка запроса к OpenAI API
        let endpoint = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        // Выполнение запроса
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NLPService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Нет данных"])))
                return
            }

            // Парсинг JSON-строки, которую вернул GPT
            do {
                let gptResponse = try JSONDecoder().decode(OpenAIChatResponse.self, from: data)
                let content = gptResponse.choices.first?.message.content ?? ""

                // Извлекаем JSON из строки (GPT возвращает JSON как текст)
                guard let jsonData = content.data(using: .utf8) else {
                    throw NSError(domain: "NLPService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Невозможно декодировать JSON-строку"])
                }

                let result = try JSONDecoder().decode(AnalysisResult.self, from: jsonData)
                completion(.success((result.summary, result.keywords)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }


    func generateQuiz(for text: String, completion: @escaping (Result<[QuizQuestion], Error>) -> Void) {
        let prompt = """
            Сгенерируй 5 тестовых вопросов по следующему тексту. Каждый вопрос с 4 вариантами ответа (один правильный). Ответ в JSON:
            [
              {
                "question": "Вопрос?",
                "options": ["A", "B", "C", "D"],
                "correctAnswer": "A"
              },
              ...
            ]
            
            Текст:
            \(text)
            """

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]

        guard let url = URL(string: "https://api.openai.com/v1/chat/completions"),
              let apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            completion(.failure(NSError(domain: "Invalid URL/API Key", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let response = try? JSONDecoder().decode(OpenAIChatResponse.self, from: data),
                  let message = response.choices.first?.message.content,
                  let questionsData = message.data(using: .utf8),
                  let questions = try? JSONDecoder().decode([QuizQuestion].self, from: questionsData) else {
                completion(.failure(NSError(domain: "Failed to parse response", code: -2)))
                return
            }

            completion(.success(questions))
        }.resume()
    }

}

// MARK: - Модели

struct OpenAIChatResponse: Decodable {
    struct Choice: Decodable {
        let message: Message
    }

    struct Message: Decodable {
        let role: String
        let content: String
    }

    let choices: [Choice]
}

struct AnalysisResult: Decodable {
    let summary: String
    let keywords: [String]
}
