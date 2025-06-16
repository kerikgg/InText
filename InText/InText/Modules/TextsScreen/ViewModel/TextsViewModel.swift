import Foundation

final class TextsViewModel: ObservableObject {
    @Published var texts: [TextModel] = []
    private var coreDataService = CoreDataService.shared

    init() {
        fetchTexts()
    }

    func fetchTexts() {
        texts = coreDataService.fetchAllTexts()
    }

    func addText(title: String, content: String) {
        coreDataService.saveText(title: title, content: content)
        fetchTexts()
    }

    func deleteText(_ text: TextModel) {
        coreDataService.deleteText(by: text.id)
        fetchTexts()
    }
}

