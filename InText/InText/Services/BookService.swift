import Foundation
import CoreData

final class BooksService {
    static let shared = BooksService()
    private let coreData = CoreDataService.shared

    func saveBook(title: String, author: String?, sourceType: SourceType) {
        coreData.saveBook(title: title, author: author, sourceType: sourceType)
    }

    func fetchAllBooks() -> [BookModel] {
        coreData.fetchAllBooks()
    }

    func deleteBook(by id: String) {
        coreData.deleteBook(by: id)
    }
}
