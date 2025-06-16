import SwiftUI
import CoreData

final class CoreDataService {
    static let shared = CoreDataService()

    private let context = PersistenceController.shared.container.viewContext

    private init() {}

    // MARK: - Save

    func saveText(title: String, content: String) {
        let newText = TextEntity(context: context)
        newText.id = UUID().uuidString
        newText.title = title
        newText.content = content
        newText.createdAt = Date()
        saveContext()
    }

    // MARK: - Fetch

    func fetchAllTexts() -> [TextModel] {
        let request: NSFetchRequest<TextEntity> = TextEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TextEntity.createdAt, ascending: false)]

        do {
            let entities = try context.fetch(request)
            return entities.map {
                TextModel(
                    id: $0.id ?? UUID().uuidString,
                    title: $0.title ?? "",
                    content: $0.content ?? "",
                    createdAt: $0.createdAt ?? Date()
                )
            }
        } catch {
            print("Ошибка загрузки: \(error)")
            return []
        }
    }

    // MARK: - Delete

    func deleteText(by id: String) {
        let request: NSFetchRequest<TextEntity> = TextEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        if let result = try? context.fetch(request).first {
            context.delete(result)
            saveContext()
        }
    }

    // MARK: - Update (по желанию)

    func updateText(id: String, newTitle: String, newContent: String) {
        let request: NSFetchRequest<TextEntity> = TextEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        if let result = try? context.fetch(request).first {
            result.title = newTitle
            result.content = newContent
            saveContext()
        }
    }

    // MARK: - Save context

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
}

