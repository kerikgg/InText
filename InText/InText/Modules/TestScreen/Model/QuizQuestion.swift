import Foundation

struct QuizQuestion: Identifiable, Codable {
    var id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: String
}
