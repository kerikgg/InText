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


//import SwiftUI
//
//struct TextDetailView: View {
//    @Environment(\.dismiss) private var dismiss
//
//    @State var title: String
//    let content: String
//    var allowSaving: Bool = false
//
//    @State private var showSavedAlert = false
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                if allowSaving {
//                    CustomTextField(title: "Введите название", text: $title)
//                } else {
//                    Text(title)
//                        .font(.title)
//                        .fontWeight(.bold)
//                }
//
//                Text(content)
//                    .font(.body)
//
//                if allowSaving {
//                    Button("Сохранить в библиотеку") {
//                        saveText()
//                    }
//                    .buttonStyle(MainActionButtonStyle())
//                }
//
//                Spacer()
//            }
//            .padding()
//        }
//        .navigationTitle("Анализ")
//        .navigationBarTitleDisplayMode(.inline)
//        .alert("Текст сохранён", isPresented: $showSavedAlert) {
//            Button("ОК") { dismiss() }
//        }
//    }
//
//    private func saveText() {
//        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
//        let finalTitle = trimmedTitle.isEmpty ? "Текст от \(formattedNow())" : trimmedTitle
//        CoreDataService.shared.saveText(title: finalTitle, content: content)
//        showSavedAlert = true
//    }
//
//    private func formattedNow() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd.MM.yyyy HH:mm"
//        return formatter.string(from: Date())
//    }
//}


//import SwiftUI
//
//struct TextDetailView: View {
//    let text: TextModel
//    var allowSaving: Bool = false
//
//    @StateObject private var vm: TextAnalysisViewModel
//    @Environment(\.dismiss) private var dismiss
//
//    init(text: TextModel, allowSaving: Bool = false) {
//        self.text = text
//        self.allowSaving = allowSaving
//        _vm = StateObject(wrappedValue: TextAnalysisViewModel(text: text))
//    }
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
//                Button("Анализировать текст") {
//                    vm.analyze()
//                }
//                .buttonStyle(MainActionButtonStyle())
//
//                if vm.isAnalyzing {
//                    ProgressView("Анализ...")
//                }
//
//                if let summary = vm.summary {
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Резюме:")
//                            .font(.headline)
//                        Text(summary)
//                    }
//                    .padding(.top)
//
//                    if !vm.keywords.isEmpty {
//                        Text("Ключевые слова:")
//                            .font(.headline)
//                            .padding(.top, 4)
//
//                        Text(vm.keywords.joined(separator: ", "))
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                }
//
//                if allowSaving {
//                    Button("Сохранить в библиотеку") {
//                        saveText()
//                        dismiss()
//                    }
//                    .buttonStyle(MainActionButtonStyle())
//                    .padding(.top)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Анализ")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//
//    private func saveText() {
//        TextsService.shared.save(text: text)
//    }
//}

import SwiftUI

struct TextDetailView: View {
    let text: TextModel
    var allowSaving: Bool = false

    @StateObject private var vm = TextAnalysisViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(text.title)
                    .font(.title)
                    .fontWeight(.bold)

                Text(text.content)
                    .font(.body)

                Divider()
                
                Picker("Метод анализа", selection: $vm.analysisMode) {
                    ForEach(AnalysisMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical)

                if !allowSaving {
                    Button("Анализировать текст") {
                        vm.analyze(textModel: text)
                    }
                    .buttonStyle(MainActionButtonStyle())

                    if vm.isAnalyzing {
                        AnimatedAnalysisView()
                    }

                    if let summary = vm.summary {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Резюме:")
                                .font(.headline)
                            Text(summary)
                        }
                        .padding(.top)

                        if !vm.keywords.isEmpty {
                            Text("Ключевые слова:")
                                .font(.headline)
                                .padding(.top, 4)

                            Text(vm.keywords.joined(separator: ", "))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                if allowSaving {
                    Divider()
                    Button("Сохранить в библиотеку") {
                        saveText()
                        dismiss()
                    }
                    .buttonStyle(MainActionButtonStyle())
                    .padding(.top)
                }
            }
            .padding()
        }
        .navigationTitle("Анализ")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let summary = text.summary, let keywords = text.keywords {
                vm.summary = summary
                vm.keywords = keywords
            }
        }
    }

    private func saveText() {
        TextsService.shared.save(text: text)
    }
}
