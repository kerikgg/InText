import Foundation

import Foundation

final class TextsService {
    static let shared = TextsService()

    private let coreData = CoreDataService.shared

    func save(text: TextModel) {
        coreData.saveText(title: text.title, content: text.content)
    }

    func updateAnalysis(for id: String, summary: String, keywords: [String]) {
        coreData.updateAnalysis(for: id, summary: summary, keywords: keywords)
    }

    func fetchAll() -> [TextModel] {
        return coreData.fetchAllTexts()
    }

    func delete(text: TextModel) {
        coreData.deleteText(by: text.id)
    }
}

