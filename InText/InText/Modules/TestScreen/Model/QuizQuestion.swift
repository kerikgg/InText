import Foundation

struct QuizQuestion: Identifiable, Codable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: String
}
