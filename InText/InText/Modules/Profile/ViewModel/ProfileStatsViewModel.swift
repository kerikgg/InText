import Foundation

final class ProfileStatsViewModel: ObservableObject {
    @Published var totalBooks: Int = 0
    @Published var totalArticles: Int = 0
    @Published var totalTexts: Int = 0
    @Published var analyzedTexts: Int = 0
    @Published var uniqueKeywords: Int = 0

    private let coreData = CoreDataService.shared

    func loadStats() {
        let allBooks = coreData.fetchAllBooks()
        totalBooks = allBooks.filter { $0.sourceType == .book }.count
        totalArticles = allBooks.filter { $0.sourceType == .article }.count

        let allTexts = allBooks.flatMap { coreData.fetchTexts(for: $0.id) }
        totalTexts = allTexts.count
        analyzedTexts = allTexts.filter { $0.summary != nil || ($0.keywords?.isEmpty == false) }.count

        let allKeywords = allTexts.compactMap { $0.keywords }.flatMap { $0 }
        let unique = Set(allKeywords.map { $0.lowercased() })
        uniqueKeywords = unique.count
    }
}

