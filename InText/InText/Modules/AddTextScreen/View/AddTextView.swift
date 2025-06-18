//import SwiftUI
//import UniformTypeIdentifiers
//
//struct AddTextView: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject private var viewModel = AddTextViewModel()
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 24) {
//                Button("Ввести вручную") {
//                    viewModel.showManualEntry = true
//                }
//                .buttonStyle(MainActionButtonStyle())
//
//                Button("Сканировать") {
//                    viewModel.showScanner = true
//                }
//                .buttonStyle(MainActionButtonStyle())
//
//                Button("Загрузить файл") {
//                    viewModel.showFilePicker = true
//                }
//                .buttonStyle(MainActionButtonStyle())
//
//                NavigationLink("", isActive: $viewModel.navigateToAnalysis) {
//                    if let text = viewModel.importedText {
//                        TextDetailView(
//                            text: TextModel(
//                                id: UUID().uuidString,
//                                title: "Новый текст",
//                                content: text,
//                                createdAt: Date()
//                            ),
//                            allowSaving: true
//                        )
//
//                        //                        TextDetailView(
//                        //                            title: "",
//                        //                            content: text,
//                        //                            allowSaving: true
//                        //                        )
//                    }
//                }
//            }
//            .padding()
//            .navigationTitle("Добавить текст")
//            .sheet(isPresented: $viewModel.showManualEntry) {
//                ManualTextEntryView { newText in
//                    viewModel.saveText(newText)
//                }
//            }
//            .sheet(isPresented: $viewModel.showScanner) {
//                OCRView { scannedText in
//                    viewModel.handleImportedText(scannedText)
//                }
//            }
//            .fileImporter(
//                isPresented: $viewModel.showFilePicker,
//                allowedContentTypes: [.plainText]
//            ) { result in
//                viewModel.handleFileResult(result)
//            }
//        }
//    }
//}
//

//import SwiftUI
//import UniformTypeIdentifiers
//
//struct AddTextView: View {
//    let bookId: String
//    @StateObject private var viewModel: AddTextViewModel
//    @State private var editingText: String?
//    @Environment(\.dismiss) var dismiss
//
//    init(bookId: String) {
//        self.bookId = bookId
//        _viewModel = StateObject(wrappedValue: AddTextViewModel(bookId: bookId))
//    }
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 24) {
//                Button("Ввести вручную") {
//                    viewModel.showManualEntry = true
//                }
//                .buttonStyle(MainActionButtonStyle(color: .purple))
//
//                Button("Сканировать") {
//                    viewModel.showScanner = true
//                }
//                .buttonStyle(MainActionButtonStyle(color: .purple))
//
//                Button("Загрузить файл") {
//                    viewModel.showFilePicker = true
//                }
//                .buttonStyle(MainActionButtonStyle(color: .purple))
//            }
//            .padding()
//            .navigationTitle("Добавить текст")
//            .sheet(isPresented: $viewModel.showManualEntry) {
//                ManualTextEntryView(bookId: bookId) { newText in
//                    viewModel.saveText(newText)
//                    dismiss()
//                }
//            }
//            .sheet(isPresented: $viewModel.showScanner) {
//                OCRView { scannedText in
//                    viewModel.handleImportedText(scannedText)
//                    dismiss()
//                }
//            }
//            .fileImporter(
//                isPresented: $viewModel.showFilePicker,
//                allowedContentTypes: [.plainText]
//            ) { result in
//                viewModel.handleFileResult(result)
//                dismiss()
//            }
//        }
//    }
//}

import SwiftUI
import UniformTypeIdentifiers

struct AddTextView: View {
    @Environment(\.dismiss) var dismiss
    @State private var editingText: IdentifiableText?
    @StateObject private var viewModel: AddTextViewModel

    var bookId: String

    init(bookId: String) {
        self.bookId = bookId
        _viewModel = StateObject(wrappedValue: AddTextViewModel(bookId: bookId))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ActionSection(
                    title: "Ввести вручную",
                    description: "Создайте отрывок с нуля, написав текст самостоятельно.",
                    action: {
                        editingText = IdentifiableText(text: "")
                    }
                )

                ActionSection(
                    title: "Сканировать",
                    description: "Используйте камеру для сканирования текста.",
                    action: {
                        viewModel.showScanner = true
                    }
                )

                ActionSection(
                    title: "Загрузить файл",
                    description: "Импортируйте текст из .txt-файла, хранящегося на устройстве.",
                    action: {
                        viewModel.showFilePicker = true
                    }
                )
                //                Button("Ввести вручную") {
                //                    editingText = IdentifiableText(text: "")
                //                }
                //                .buttonStyle(MainActionButtonStyle(color: .purple))
                //
                //                Button("Сканировать") {
                //                    viewModel.showScanner = true
                //                }
                //                .buttonStyle(MainActionButtonStyle(color: .purple))
                //
                //                Button("Загрузить файл") {
                //                    viewModel.showFilePicker = true
                //                }
                //                .buttonStyle(MainActionButtonStyle(color: .purple))
            }
            .padding()
            .navigationTitle("Добавить отрывок")
            .sheet(isPresented: $viewModel.showScanner) {
                OCRView { scannedText in
                    editingText = IdentifiableText(text: scannedText)
                }
            }
            .fileImporter(
                isPresented: $viewModel.showFilePicker,
                allowedContentTypes: [.plainText]
            ) { result in
                viewModel.handleFileResult(result) { content in
                    editingText = IdentifiableText(text: content)
                }
            }
            .sheet(item: $editingText) { item in
                TextEditorSheet(initialText: item.text) { title, finalText in
                    CoreDataService.shared.saveText(title: title, content: finalText, bookId: bookId)
                    dismiss()
                }
            }
        }
    }
}
