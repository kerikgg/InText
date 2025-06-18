//import SwiftUI
//
//struct ManualTextEntryView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var text = ""
//    var onSave: (String) -> Void
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                TextEditor(text: $text)
//                    .padding()
//                    .frame(height: 300)
//                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
//                
//                Spacer()
//
//                Button("Сохранить") {
//                    onSave(text)
//                    dismiss()
//                }
//                .buttonStyle(MainActionButtonStyle())
//                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
//            }
//            .padding()
//            .navigationTitle("Ввести вручную")
//        }
//    }
//}
//

import SwiftUI

struct ManualTextEntryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var content: String = ""
    let bookId: String

    let onSave: (TextModel) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                CustomTextField(title: "Заголовок", text: $title)
//                TextField("Заголовок", text: $title)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextEditor(text: $content)
                    .frame(height: 300)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5)))

                Spacer()

                Button("Сохранить") {
                    let newText = TextModel(
                        id: UUID().uuidString,
                        bookId: bookId,
                        title: title.isEmpty ? "Без названия" : title,
                        content: content,
                        createdAt: Date()
                    )
                    onSave(newText)
                    dismiss()
                }
                .buttonStyle(MainActionButtonStyle(color: content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .purple))
                .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .navigationTitle("Ввести текст")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
