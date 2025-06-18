//import SwiftUI
//import CoreData
//
//final class CoreDataService {
//    static let shared = CoreDataService()
//    private let context = PersistenceController.shared.container.viewContext
//
//    private init() {}
//
//    // MARK: - Save
//
//    //    func saveText(title: String, content: String) {
//    //        let newText = TextEntity(context: context)
//    //        newText.id = UUID().uuidString
//    //        newText.title = title
//    //        newText.content = content
//    //        newText.createdAt = Date()
//    //        saveContext()
//    //    }
//
////    func saveText(title: String, content: String, bookId: String) {
////        let newText = TextEntity(context: context)
////        newText.id = UUID().uuidString
////        newText.title = title
////        newText.content = content
////        newText.bookId = bookId
////        newText.createdAt = Date()
////        saveContext()
////    }
//
//
//
//    // MARK: - Fetch
//    func fetchTexts(for bookId: String) -> [TextModel] {
//        let request: NSFetchRequest<TextEntity> = TextEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "bookId == %@", bookId)
//        request.sortDescriptors = [NSSortDescriptor(keyPath: \TextEntity.createdAt, ascending: false)]
//
//        do {
//            return try context.fetch(request).map {
//                TextModel(
//                    id: $0.id ?? UUID().uuidString,
//                    bookId: $0.bookId ?? "",
//                    title: $0.title ?? "",
//                    content: $0.content ?? "",
//                    createdAt: $0.createdAt ?? Date(),
//                    summary: $0.summary,
//                    keywords: $0.keywords?.components(separatedBy: ", ")
//                )
//            }
//        } catch {
//            print("Ошибка загрузки отрывков: \(error)")
//            return []
//        }
//    }
//
//
//    func fetchAllTexts() -> [TextModel] {
//        let request: NSFetchRequest<TextEntity> = TextEntity.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(keyPath: \TextEntity.createdAt, ascending: false)]
//
//        do {
//            let entities = try context.fetch(request)
//            return entities.map {
//                TextModel(
//                    id: $0.id ?? UUID().uuidString,
//                    bookId: UUID().uuidString,
//                    title: $0.title ?? "",
//                    content: $0.content ?? "",
//                    createdAt: $0.createdAt ?? Date(),
//                    summary: $0.summary,
//                    keywords: $0.keywords?.components(separatedBy: ", ")
//                )
//            }
//        } catch {
//            print("Ошибка загрузки: \(error)")
//            return []
//        }
//    }
//
//    // MARK: - Delete
//
//    func deleteText(by id: String) {
//        let request: NSFetchRequest<TextEntity> = TextEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id)
//
//        if let result = try? context.fetch(request).first {
//            context.delete(result)
//            saveContext()
//        }
//    }
//
//    // MARK: - Update (по желанию)
//
//    func updateText(id: String, newTitle: String, newContent: String) {
//        let request: NSFetchRequest<TextEntity> = TextEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id)
//
//        if let result = try? context.fetch(request).first {
//            result.title = newTitle
//            result.content = newContent
//            saveContext()
//        }
//    }
//
//    func updateAnalysis(for id: String, summary: String, keywords: [String]) {
//        let request: NSFetchRequest<TextEntity> = TextEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id)
//
//        do {
//            if let textEntity = try context.fetch(request).first {
//                textEntity.summary = summary
//                textEntity.keywords = keywords.joined(separator: ", ")
//
//                try context.save()
//                print("Анализ успешно сохранён в Core Data")
//            } else {
//                print("Текст с id \(id) не найден")
//            }
//        } catch {
//            print("Ошибка при обновлении анализа: \(error)")
//        }
//    }
//
//    // MARK: - Save Book
//
//    func saveBook(title: String) {
//        let book = BookEntity(context: context)
//        book.id = UUID().uuidString
//        book.title = title
//        book.createdAt = Date()
//        saveContext()
//    }
//
//    // MARK: - Fetch Books
//
//    func fetchAllBooks() -> [BookModel] {
//        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(keyPath: \BookEntity.createdAt, ascending: false)]
//
//        do {
//            return try context.fetch(request).map {
//                BookModel(
//                    id: $0.id ?? UUID().uuidString,
//                    title: $0.title ?? "",
//                    createdAt: $0.createdAt ?? Date()
//                )
//            }
//        } catch {
//            print("Ошибка загрузки книг: \(error)")
//            return []
//        }
//    }
//
//    func deleteBook(by id: String) {
//        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id)
//
//        if let entity = try? context.fetch(request).first {
//            context.delete(entity)
//            saveContext()
//        }
//    }
//
//    // MARK: - Save context
//
//    private func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            print("Ошибка сохранения: \(error)")
//        }
//    }
//}
//

import SwiftUI
import CoreData


final class CoreDataService {
    static let shared = CoreDataService()
    private let context = PersistenceController.shared.container.viewContext

    private init() {}

    // MARK: - BOOKS

    func saveBook(title: String, author: String?, sourceType: SourceType) {
        let book = BookEntity(context: context)
        book.id = UUID().uuidString
        book.title = title
        book.author = author
        book.sourceType = sourceType.rawValue
        book.createdAt = Date()
        saveContext()
    }

    func fetchAllBooks() -> [BookModel] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \BookEntity.createdAt, ascending: false)]

        do {
            let result = try context.fetch(request)
            return result.map {
                BookModel(
                    id: $0.id ?? "",
                    title: $0.title ?? "",
                    createdAt: $0.createdAt ?? Date(),
                    author: $0.author,
                    sourceType: SourceType(rawValue: $0.sourceType ?? "") ?? .book
                )
            }
        } catch {
            print("Ошибка загрузки книг: \(error)")
            return []
        }
    }

    func deleteBook(by id: String) {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let book = try? context.fetch(request).first {
            context.delete(book)
            saveContext()
        }
    }

    // MARK: - TEXTS

    func saveText(title: String, content: String, bookId: String) {
        let newText = TextEntity(context: context)
        newText.id = UUID().uuidString
        newText.title = title
        newText.content = content
        newText.createdAt = Date()
        newText.bookId = bookId
        saveContext()
    }

    func fetchTexts(for bookId: String) -> [TextModel] {
        let request: NSFetchRequest<TextEntity> = TextEntity.fetchRequest()
        request.predicate = NSPredicate(format: "bookId == %@", bookId)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TextEntity.createdAt, ascending: false)]

        do {
            let result = try context.fetch(request)
            return result.map {
                TextModel(
                    id: $0.id ?? "",
                    bookId: bookId,
                    title: $0.title ?? "",
                    content: $0.content ?? "",
                    createdAt: $0.createdAt ?? Date(),
                    summary: $0.summary,
                    keywords: $0.keywords?.components(separatedBy: ", ")
                )
            }
        } catch {
            print("Ошибка загрузки текстов: \(error)")
            return []
        }
    }

    func fetchAllTexts() -> [TextModel] {
        let request: NSFetchRequest<TextEntity> = TextEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TextEntity.createdAt, ascending: false)
        ]

        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                TextModel(
                    id: entity.id ?? UUID().uuidString,
                    bookId: entity.bookId ?? "",
                    title: entity.title ?? "",
                    content: entity.content ?? "",
                    createdAt: entity.createdAt ?? Date(),
                    summary: entity.summary,
                    keywords: entity.keywords?.components(separatedBy: ", ")
                )
            }
        } catch {
            print("❌ Ошибка загрузки текстов: \(error)")
            return []
        }
    }


    func deleteText(by id: String) {
        let request: NSFetchRequest<TextEntity> = TextEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let text = try? context.fetch(request).first {
            context.delete(text)
            saveContext()
        }
    }

    func updateAnalysis(for id: String, summary: String, keywords: [String]) {
        let request: NSFetchRequest<TextEntity> = TextEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            if let text = try context.fetch(request).first {
                text.summary = summary
                text.keywords = keywords.joined(separator: ", ")
                try context.save()
            }
        } catch {
            print("Ошибка обновления анализа: \(error)")
        }
    }

    // Удалить все записи указанной сущности
    func deleteAllEntities(named entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Все записи \(entityName) удалены.")
        } catch {
            print("Ошибка удаления всех записей \(entityName): \(error.localizedDescription)")
        }
    }

    // Удалить все тексты
    func deleteAllTexts() {
        deleteAllEntities(named: "TextEntity")
    }

    // Удалить все книги
    func deleteAllBooks() {
        deleteAllEntities(named: "BookEntity")
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
}

