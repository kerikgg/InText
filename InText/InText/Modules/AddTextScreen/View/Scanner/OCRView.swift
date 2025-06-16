//import SwiftUI
//import VisionKit
//
//struct OCRView: View {
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var viewModel = OCRViewModel()
//
//    let onScan: (String) -> Void
//
//    var body: some View {
//        Group {
//            switch viewModel.accessStatus {
//            case .scannerAvailable:
//                OCRScannerView(onScan: { text in
//                    onScan(text)
//                    dismiss()
//                })
//
//            case .cameraNotAvailable:
//                Text("Камера недоступна")
//            case .cameraAccessNotGranted:
//                Text("Нет доступа к камере")
//            case .scannerNotAvailable:
//                Text("Сканер не поддерживается на этом устройстве")
//            case .notDetermined:
//                ProgressView("Запрос доступа...")
//            }
//        }
//        .task {
//            await viewModel.requestAccess()
//        }
//    }
//}
//


//struct OCRView: View {
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var viewModel = OCRViewModel()
//    @State private var recognizedText: String = ""
//
//    let onScan: (String) -> Void
//
//    var body: some View {
//        VStack {
//            ZStack {
//                OCRScannerView(realTimeText: $recognizedText)
//            }
//            .frame(maxHeight: .infinity)
//
//            VStack(spacing: 12) {
//                if !recognizedText.isEmpty {
//                    Text("Найдено символов: \(recognizedText.count)")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//
//                    Button("Сохранить") {
//                        onScan(recognizedText)
//                        dismiss()
//                    }
//                    .buttonStyle(MainActionButtonStyle())
//                }
//
//                Button("Отмена") {
//                    dismiss()
//                }
//                .foregroundColor(.red)
//            }
//            .padding()
//        }
//        .task {
//            await viewModel.requestAccess()
//        }
//    }
//}
//

//struct OCRView: View {
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var viewModel = SelectableOCRViewModel()
//
//    let onScan: (String) -> Void
//
//    var body: some View {
//        VStack {
//            OCRScannerView(onTextRecognized: { text in
//                viewModel.add(text)
//            })
//            .frame(height: 300)
//
//            ForEach($viewModel.recognizedItems) { $item in
//                Text(item.text)
//                    .padding()
//                    .background(item.isSelected ? Color.purple.opacity(0.2) : Color.gray.opacity(0.1))
//                    .cornerRadius(12)
//                    .onTapGesture {
//                        item.isSelected.toggle()
//                    }
//            }
//
//            if !viewModel.recognizedItems.isEmpty {
//                Button("Сохранить выбранное") {
//                    onScan(viewModel.selectedText)
//                    dismiss()
//                }
//                .buttonStyle(MainActionButtonStyle())
//                .padding(.top)
//            }
//
//            Button("Отмена") {
//                dismiss()
//            }
//            .foregroundColor(.red)
//        }
//        .padding()
//    }
//}

//import SwiftUI
//import ImageOCRUI
//
//struct OCRView: View {
//    @Environment(\.dismiss) private var dismiss
//    @State private var recognizedItems: [RecognizedTextItem] = []
//    @State private var showEditor = false
//    @State private var finalTextToEdit = ""
//
//    let onScan: (String) -> Void
//
//    var body: some View {
//        VStack {
//            if recognizedItems.isEmpty {
//                ScannerView { pages in
//                    if let pages = pages {
//                        self.recognizedItems = pages.map { RecognizedTextItem(text: $0) }
//                    } else {
//                        dismiss()
//                    }
//                }
//            } else {
//                ScrollView {
//                    LazyVStack(spacing: 8) {
//                        ForEach($recognizedItems) { $item in
//                            Text(item.text)
//                                .padding()
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .background(item.isSelected ? Color.purple.opacity(0.2) : Color.gray.opacity(0.1))
//                                .cornerRadius(10)
//                                .onTapGesture {
//                                    item.isSelected.toggle()
//                                }
//                        }
//                    }
//                    .padding()
//                }
//
//                VStack(spacing: 12) {
//                    Button("Редактировать выбранное") {
//                        finalTextToEdit = selectedText
//                        showEditor = true
//                    }
//
//                    Button("Сохранить") {
//                        onScan(selectedText)
//                        dismiss()
//                    }
//                    .buttonStyle(MainActionButtonStyle())
//
//                    Button("Отмена") {
//                        dismiss()
//                    }
//                    .foregroundColor(.red)
//                }
//                .padding()
//            }
//        }
//        .sheet(isPresented: $showEditor) {
//            TextEditorSheet(initialText: finalTextToEdit) { editedText in
//                onScan(editedText)
//                dismiss()
//            }
//        }
//    }
//
//    private var selectedText: String {
//        recognizedItems
//            .filter { $0.isSelected }
//            .map { $0.text }
//            .joined(separator: "\n\n")
//    }
//}

import SwiftUI
import ImageOCRUI

struct OCRView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var fullText: String = ""
    @State private var isEditing = false

    let onScan: (String) -> Void

    var body: some View {
        VStack {
            if fullText.isEmpty {
                ScannerView { pages in
                    if let pages = pages {
                        self.fullText = pages.joined(separator: "\n\n")
                        self.isEditing = true
                    } else {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            TextEditorSheet(initialText: fullText) { editedText in
                onScan(editedText)
                dismiss()
            }
        }
    }
}
