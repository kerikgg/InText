import SwiftUI

struct QuizView: View {
    @Binding var isPresented: Bool
    @StateObject private var vm = QuizViewModel()
    let text: String

    var body: some View {
        VStack(spacing: 20) {
            if let question = vm.currentQuestion {
                Text(question.question)
                    .font(.title3)
                    .bold()

                ForEach(question.options, id: \.self) { option in
                    Button(action: {
                        vm.selectAnswer(option)
                    }) {
                        Text(option)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }

            } else {
                ProgressView("Генерация теста...")
            }
        }
        .padding()
        .onAppear {
            vm.loadQuestions(for: text)
        }
        .sheet(isPresented: $vm.showResult, onDismiss: {
            isPresented = false
        }) {
            VStack {
                Text("Результат")
                    .font(.title)
                Text("Правильных ответов: \(vm.correctCount) из \(vm.questions.count)")
                Button("Закрыть") {
                    vm.showResult = false
                }
                .padding(.top)
            }
            .padding()
        }
    }
}

