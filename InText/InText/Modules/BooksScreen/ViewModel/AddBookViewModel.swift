import Foundation

@MainActor
final class AddBookViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var sourceType: SourceType = .book
    private let booksService = BooksService.shared

    func save() {
        booksService.saveBook(title: title, author: author, sourceType: sourceType)
    }

    var canSubmit: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
