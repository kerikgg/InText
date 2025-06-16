import SwiftUI
import UniformTypeIdentifiers

struct AddTextView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AddTextViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Button("Ввести вручную") {
                    viewModel.showManualEntry = true
                }
                .buttonStyle(MainActionButtonStyle())

                Button("Сканировать") {
                    viewModel.showScanner = true
                }
                .buttonStyle(MainActionButtonStyle())

                Button("Загрузить файл") {
                    viewModel.showFilePicker = true
                }
                .buttonStyle(MainActionButtonStyle())

                NavigationLink("", isActive: $viewModel.navigateToAnalysis) {
                    if let text = viewModel.importedText {
                        TextDetailView(
                            title: "",
                            content: text,
                            allowSaving: true
                        )
                    }
                }
            }
            .padding()
            .navigationTitle("Добавить текст")
            .sheet(isPresented: $viewModel.showManualEntry) {
                ManualTextEntryView(onSave: { text in
                    viewModel.handleImportedText(text)
                })
            }
            .sheet(isPresented: $viewModel.showScanner) {
                OCRView { scannedText in
                    viewModel.handleImportedText(scannedText)
                }
            }
            .fileImporter(
                isPresented: $viewModel.showFilePicker,
                allowedContentTypes: [.plainText]
            ) { result in
                viewModel.handleFileResult(result)
            }
        }
    }
}

