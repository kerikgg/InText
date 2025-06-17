import Foundation

enum Secrets {
    static var openAIKey: String {
        guard let key = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            fatalError("API Key не найден в Info.plist")
        }
        return key
    }
}
