import Foundation

enum FileImportError: Error, LocalizedError {
    case unsupportedFormat
    case accessDenied
    case readFailed
    case copyFailed

    var errorDescription: String? {
        switch self {
        case .unsupportedFormat:
            return "Формат файла не поддерживается."
        case .accessDenied:
            return "Нет доступа к файлу."
        case .readFailed:
            return "Не удалось прочитать содержимое файла."
        case .copyFailed:
            return "Ошибка копирования файла в хранилище приложения."
        }
    }
}

final class FileImportService {
    static let shared = FileImportService()

    private init() {}

    func importTextFile(from url: URL) -> Result<String, FileImportError> {
        guard url.startAccessingSecurityScopedResource() else {
            return .failure(.accessDenied)
        }
        defer { url.stopAccessingSecurityScopedResource() }

        let fileManager = FileManager.default
        let tempURL = fileManager.temporaryDirectory.appendingPathComponent(url.lastPathComponent)

        do {
            if fileManager.fileExists(atPath: tempURL.path) {
                try fileManager.removeItem(at: tempURL)
            }

            try fileManager.copyItem(at: url, to: tempURL)

            let text = try String(contentsOf: tempURL, encoding: .utf8)
            return .success(text)

        } catch {
            print("DEBUG COPY ERROR: \(error)")
            return .failure(.copyFailed)
        }
    }
}

