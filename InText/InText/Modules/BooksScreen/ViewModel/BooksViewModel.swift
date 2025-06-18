//import Foundation
//import SwiftUI
//
//final class BooksViewModel: ObservableObject {
//    @Published var books: [BookModel] = []
//
//    private let bookService = BooksService.shared
//
//    func fetchBooks() {
//        books = bookService.fetchAllBooks()
//    }
//
//    func deleteBook(at offsets: IndexSet) {
//        let filtered = books.filter { $0.sourceType }
//        for index in offsets {
//            let book = filtered[index]
//            CoreDataService.shared.deleteBook(by: book.id)
//        }
//        fetchBooks()
//
//        //        for index in offsets {
//        //            let book = books[index]
//        //            bookService.delete(id: book.id)
//        //        }
//        //        fetchBooks()
//    }
//}
//

import Foundation

final class BooksViewModel: ObservableObject {
    @Published var books: [BookModel] = []
    @Published var articles: [BookModel] = []

    private let service = BooksService.shared

    init() {
        fetchBooks()
    }

    func fetchBooks() {
        let all = service.fetchAllBooks()

        books = all.filter { $0.sourceType == .book }
        articles = all.filter { $0.sourceType == .article }
    }

    func addBook(title: String, author: String?, sourceType: SourceType) {
        service.saveBook(title: title, author: author, sourceType: sourceType)
        fetchBooks()
    }

    func deleteBook(_ book: BookModel) {
        service.deleteBook(by: book.id)
        fetchBooks()
    }
}
