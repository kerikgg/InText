import SwiftUI
import UniformTypeIdentifiers

final class AddTextViewModel: ObservableObject {
    @Published var showManualEntry = false
    @Published var showScanner = false
    @Published var showFilePicker = false

    @Published var importedText: String?
    @Published var navigateToAnalysis = false

    func handleImportedText(_ text: String) {
        importedText = text
        navigateToAnalysis = true
    }

    func handleFileResult(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            switch FileImportService.shared.importTextFile(from: url) {
            case .success(let content):
                handleImportedText(content)
            case .failure(let error):
                print("Ошибка импорта: \(error.localizedDescription)")
            }
        case .failure(let error):
            print("Ошибка выбора файла: \(error.localizedDescription)")
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

