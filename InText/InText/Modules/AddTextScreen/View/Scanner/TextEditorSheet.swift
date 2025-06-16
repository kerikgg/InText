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

import SwiftUI

struct TextEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text: String
    let onSave: (String) -> Void

    init(initialText: String, onSave: @escaping (String) -> Void) {
        _text = State(initialValue: initialText)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $text)
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    .padding()

                Button("Сохранить") {
                    onSave(text)
                    dismiss()
                }
                .buttonStyle(MainActionButtonStyle())
                .padding()
            }
            .navigationTitle("Редактирование")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
