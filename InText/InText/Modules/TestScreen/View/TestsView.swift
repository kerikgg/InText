import SwiftUI

struct TestsView: View {
    @State private var selectedText: TextModel?
    @State private var texts: [TextModel] = []

    var body: some View {
        NavigationStack {
            VStack {
                if texts.isEmpty {
                    Text("Нет сохранённых текстов для тестирования")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(texts) { text in
                        Button(action: {
                            selectedText = text
                        }) {
                            VStack(alignment: .leading) {
                                Text(text.title)
                                    .font(.headline)
                                Text(text.createdAt.formattedString)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            //.toolbarBackgroundVisibility(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Тестирование")
            .onAppear(perform: loadTexts)
            .sheet(item: $selectedText) { selected in
                QuizView(isPresented: Binding(
                    get: { selectedText != nil },
                    set: { newValue in
                        if !newValue {
                            selectedText = nil
                        }
                    }
                ), text: selected.content)
            }
        }
    }
    private func loadTexts() {
        texts = TextsService.shared.fetchAll()
    }
}
