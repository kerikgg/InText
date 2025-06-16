import SwiftUI

struct ManualTextEntryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var text = ""
    var onSave: (String) -> Void

    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $text)
                    .padding()
                    .frame(height: 300)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                
                Spacer()

                Button("Сохранить") {
                    onSave(text)
                    dismiss()
                }
                .buttonStyle(MainActionButtonStyle())
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .navigationTitle("Ввести вручную")
        }
    }
}

