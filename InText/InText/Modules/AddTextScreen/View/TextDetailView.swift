//import SwiftUI
//
//struct TextDetailView: View {
//    let text: TextModel
//    var allowSaving: Bool = false
//
//    @Environment(\.dismiss) private var dismiss
//    @State private var showSavedAlert = false
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                Text(text.title)
//                    .font(.title)
//                    .fontWeight(.bold)
//
//                Text(text.content)
//                    .font(.body)
//
//                if allowSaving {
//                    Button("Сохранить в библиотеку") {
//                        saveText()
//                    }
//                    .buttonStyle(MainActionButtonStyle())
//                    .padding(.top)
//                }
//
//                Spacer()
//            }
//        }
//        .padding()
//        .navigationTitle("Анализ")
//        .navigationBarTitleDisplayMode(.inline)
//        .alert("Текст сохранён", isPresented: $showSavedAlert) {
//            Button("ОК") {
//                dismiss() // Закрываем экран
//            }
//        }
//    }
//
//    private func saveText() {
//        CoreDataService.shared.saveText(title: text.title, content: text.content)
//        showSavedAlert = true
//    }
//}


import SwiftUI

struct TextDetailView: View {
    @Environment(\.dismiss) private var dismiss

    @State var title: String
    let content: String
    var allowSaving: Bool = false

    @State private var showSavedAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if allowSaving {
                    CustomTextField(title: "Введите название", text: $title)
                } else {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                }

                Text(content)
                    .font(.body)

                if allowSaving {
                    Button("Сохранить в библиотеку") {
                        saveText()
                    }
                    .buttonStyle(MainActionButtonStyle())
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Анализ")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Текст сохранён", isPresented: $showSavedAlert) {
            Button("ОК") { dismiss() }
        }
    }

    private func saveText() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalTitle = trimmedTitle.isEmpty ? "Текст от \(formattedNow())" : trimmedTitle
        CoreDataService.shared.saveText(title: finalTitle, content: content)
        showSavedAlert = true
    }

    private func formattedNow() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: Date())
    }
}
