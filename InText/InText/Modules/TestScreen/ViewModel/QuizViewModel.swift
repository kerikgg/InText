import Foundation

@MainActor
final class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var currentIndex = 0
    @Published var selectedAnswer: String?
    @Published var showResult = false
    @Published var correctCount = 0

    var currentQuestion: QuizQuestion? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    func selectAnswer(_ answer: String) {
        selectedAnswer = answer
        if answer == currentQuestion?.correctAnswer {
            correctCount += 1
        }
        next()
    }

    private func next() {
        if currentIndex + 1 < questions.count {
            currentIndex += 1
            selectedAnswer = nil
        } else {
            showResult = true
        }
    }

    func loadQuestions(for text: String) {
        NLPService.shared.generateQuiz(for: text) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let quiz):
                    self?.questions = quiz
                case .failure(let error):
                    print("Ошибка: \(error)")
                }
            }
        }
    }
}

