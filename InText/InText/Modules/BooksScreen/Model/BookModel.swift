import Foundation

struct BookModel: Identifiable, Codable {
    let id: String
    let title: String
    let createdAt: Date
    let author: String?
    let sourceType: SourceType
}
