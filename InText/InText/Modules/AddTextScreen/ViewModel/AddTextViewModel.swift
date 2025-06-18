//import SwiftUI
//import UniformTypeIdentifiers
//
//final class AddTextViewModel: ObservableObject {
//    @Published var showManualEntry = false
//    @Published var showScanner = false
//    @Published var showFilePicker = false
//
//    @Published var importedText: String?
//    @Published var navigateToAnalysis = false
//
//    func handleImportedText(_ text: String) {
//        importedText = text
//        navigateToAnalysis = true
//    }
//
//    func handleFileResult(_ result: Result<URL, Error>) {
//        switch result {
//        case .success(let url):
//            switch FileImportService.shared.importTextFile(from: url) {
//            case .success(let content):
//                handleImportedText(content)
//            case .failure(let error):
//                print("Ошибка импорта: \(error.localizedDescription)")
//            }
//        case .failure(let error):
//            print("Ошибка выбора файла: \(error.localizedDescription)")
//        }
//    }
//
//
//    //    func handleFileResult(_ result: Result<URL, Error>) {
//    //        switch result {
//    //        case .success(let url):
//    //            if let content = try? String(contentsOf: url) {
//    //                handleImportedText(content)
//    //            }
//    //        case .failure(let error):
//    //            print("Ошибка загрузки файла: \(error.localizedDescription)")
//    //        }
//    //    }
//}
//


//import SwiftUI
//import UniformTypeIdentifiers
//
//final class AddTextViewModel: ObservableObject {
//    @Published var showManualEntry = false
//    @Published var showScanner = false
//    @Published var showFilePicker = false
//
//    private let textService = Texts.shared // или FirestoreService
//
//    func saveText(_ text: TextModel) {
//        textService.saveText(text)
//    }
//
//    func handleImportedText(_ text: String) {
//        let newText = TextModel(
//            id: UUID().uuidString,
//            title: "Загруженный текст",
//            content: text,
//            createdAt: Date()
//        )
//        saveText(newText)
//    }
//
//    func handleFileResult(_ result: Result<URL, Error>) {
//        switch result {
//        case .success(let url):
//            if let content = try? String(contentsOf: url) {
//                handleImportedText(content)
//            }
//        case .failure(let error):
//            print("Ошибка загрузки файла: \(error.localizedDescription)")
//        }
//    }
//}

import Foundation

//final class AddTextViewModel: ObservableObject {
//    @Published var showManualEntry = false
//    @Published var showScanner = false
//    @Published var showFilePicker = false
//
//    private let textService = CoreDataService.shared
//
//    func saveText(_ text: TextModel) {
//        textService.saveText(title: text.title, content: text.content)
//    }
//
//    func handleImportedText(_ content: String) {
//        let newText = TextModel(
//            id: UUID().uuidString,
//            title: "Загруженный текст",
//            content: content,
//            createdAt: Date()
//        )
//        saveText(newText)
//    }
//
//    func handleFileResult(_ result: Result<URL, Error>) {
//        switch result {
//        case .success(let url):
//            if let content = try? String(contentsOf: url) {
//                handleImportedText(content)
//            }
//        case .failure(let error):
//            print("Ошибка загрузки файла: \(error.localizedDescription)")
//        }
//    }
//}

final class AddTextViewModel: ObservableObject {
    @Published var showManualEntry = false
    @Published var showScanner = false
    @Published var showFilePicker = false

    private let textService = CoreDataService.shared
    private let bookId: String

    init(bookId: String) {
        self.bookId = bookId
    }

    func saveText(_ text: TextModel) {
        textService.saveText(title: text.title, content: text.content, bookId: text.bookId)
    }

    func handleImportedText(_ content: String) {
        let newText = TextModel(
            id: UUID().uuidString,
            bookId: bookId,
            title: "Загруженный текст",
            content: content,
            createdAt: Date(),
            summary: nil,
            keywords: nil
        )
        saveText(newText)
    }

    func handleFileResult(_ result: Result<URL, Error>, completion: @escaping (String) -> Void) {
        switch result {
        case .success(let url):
            if let content = try? String(contentsOf: url) {
                completion(content)
            }
        case .failure(let error):
            print("Ошибка загрузки файла: \(error.localizedDescription)")
        }
    }

    //    func handleFileResult(_ result: Result<URL, Error>) {
    //        switch result {
    //        case .success(let url):
    //            if let content = try? String(contentsOf: url) {
    //                handleImportedText(content)
    //            }
    //        case .failure(let error):
    //            print("Ошибка загрузки файла: \(error.localizedDescription)")
    //        }
    //    }
}
