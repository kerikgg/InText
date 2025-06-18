//import SwiftUI
//
//struct TextEditorSheet: View {
//    @Environment(\.dismiss) private var dismiss
//    @State private var text: String
//    let onSave: (String) -> Void
//
//    init(initialText: String, onSave: @escaping (String) -> Void) {
//        _text = State(initialValue: initialText)
//        self.onSave = onSave
//    }
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                TextEditor(text: $text)
//                    .padding()
//                    .background(Color.gray.opacity(0.05))
//                    .cornerRadius(12)
//                    .padding()
//
//                Button("Сохранить") {
//                    onSave(text)
//                    dismiss()
//                }
//                .buttonStyle(MainActionButtonStyle())
//                .padding()
//            }
//            .navigationTitle("Редактирование")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//

//import SwiftUI
//
//struct TextEditorSheet: View {
//    @Environment(\.dismiss) private var dismiss
//    @State private var text: String
//    let onSave: (String) -> Void
//
//    init(initialText: String, onSave: @escaping (String) -> Void) {
//        _text = State(initialValue: initialText)
//        self.onSave = onSave
//    }
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                TextEditor(text: $text)
//                    .padding()
//                    .background(Color.gray.opacity(0.05))
//                    .cornerRadius(12)
//                    .padding()
//
//                Button("Сохранить") {
//                    onSave(text)
//                    dismiss()
//                }
//                .buttonStyle(MainActionButtonStyle(color: .purple))
//                .padding()
//            }
//            .navigationTitle("Редактирование")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}


import SwiftUI

struct TextEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var text: String
    let onSave: (String, String) -> Void

    init(initialTitle: String = "", initialText: String, onSave: @escaping (String, String) -> Void) {
        _title = State(initialValue: initialTitle)
        _text = State(initialValue: initialText)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                CustomTextField(title: "Название", text: $title)
                    .padding()

                TextEditor(text: $text)
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.horizontal)

                Button("Сохранить") {
                    onSave(title, text)
                    dismiss()
                }
                .buttonStyle(MainActionButtonStyle(color: .purple))
                .padding()
            }
            .navigationTitle("Редактирование")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
