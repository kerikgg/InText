//import Foundation
//
//struct LocalAnalysisService {
//    static func analyze(text: String) -> (summary: String, keywords: [String]) {
//        let sentences = text.components(separatedBy: ". ")
//        let words = text.lowercased()
//            .components(separatedBy: CharacterSet.alphanumerics.inverted)
//            .filter { !$0.isEmpty && !stopWords.contains($0) }
//
//        let frequencies = Dictionary(grouping: words, by: { $0 }).mapValues { $0.count }
//        let sortedKeywords = frequencies.sorted { $0.value > $1.value }
//        let topKeywords = sortedKeywords.prefix(10).map { $0.key }
//
//        // Простейшее саммари — первые 3 предложения, содержащие ключевые слова
//        let summary = sentences
//            .filter { s in topKeywords.contains { s.lowercased().contains($0) } }
//            .prefix(3)
//            .joined(separator: ". ") + "."
//
//        return (summary: summary, keywords: topKeywords)
//    }
//
//    static let stopWords: Set<String> = [
//        "и", "в", "на", "не", "что", "с", "как", "по", "из", "у", "за", "от", "до", "а", "но", "или", "это", "то", "бы", "о"
//    ]
//}

//import Foundation
//import NaturalLanguage
//
//struct LocalAnalysisService {
//
//    /// Основной метод анализа текста
//    static func analyze(text: String) -> (summary: String, keywords: [String]) {
//        let summary = generateSummary(from: text)
//        let keywords = extractKeywords(from: text)
//        return (summary, keywords)
//    }
//
//    /// Извлекает первые 1–2 предложения как резюме
//    private static func generateSummary(from text: String) -> String {
//        let sentences = text
//            .components(separatedBy: CharacterSet(charactersIn: ".!?"))
//            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
//            .filter { !$0.isEmpty }
//
//        return sentences.prefix(3).joined(separator: ". ") + "."
//    }
//
//    /// Извлекает ключевые слова с лемматизацией и частотным анализом
//    private static func extractKeywords(from text: String) -> [String] {
//        let lemmas = lemmatize(text: text)
//        let filtered = lemmas
//            .filter { $0.count > 2 }
//            .filter { !stopWords.contains($0) }
//
//        let frequencies = Dictionary(filtered.map { ($0, 1) }, uniquingKeysWith: +)
//        let sorted = frequencies.sorted { $0.value > $1.value }
//        let topKeywords = sorted.prefix(5).map { $0.key }
//
//        return topKeywords
//    }
//
//    /// Лемматизация текста (приведение к начальной форме)
//    private static func lemmatize(text: String) -> [String] {
//        let tagger = NSLinguisticTagger(tagSchemes: [.lemma], options: 0)
//        tagger.string = text
//
//        var lemmas: [String] = []
//        let range = NSRange(location: 0, length: text.utf16.count)
//
//        tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: [.omitPunctuation, .omitWhitespace]) { tag, tokenRange, _ in
//            let token = (text as NSString).substring(with: tokenRange).lowercased()
//
//            if let lemma = tag?.rawValue.lowercased() {
//                lemmas.append(lemma)
//            } else {
//                lemmas.append(token)
//            }
//        }
//
//        return lemmas
//    }
//
//    /// Базовый список стоп-слов на русском языке
//    private static let stopWords: Set<String> = [
//        "и", "в", "во", "не", "что", "он", "на", "я", "с", "со", "как", "а", "то",
//        "все", "она", "так", "его", "но", "да", "ты", "к", "у", "же", "вы", "за",
//        "бы", "по", "только", "ее", "мне", "было", "вот", "от", "меня", "еще",
//        "нет", "о", "из", "ему", "теперь", "когда", "даже", "ну", "вдруг", "ли",
//        "если", "уже", "или", "ни", "быть", "был", "него", "до", "вас", "нибудь",
//        "опять", "уж", "вам", "ведь", "там", "потом", "себя", "ничего", "ей",
//        "может", "они", "тут", "где", "есть", "надо", "ней", "для", "мы", "тебя",
//        "их", "чем", "была", "сам", "чтоб", "без", "будто", "чего", "раз", "тоже",
//        "себе", "под", "будет", "ж", "тогда", "кто", "этот"
//    ]
//}

//import Foundation
//import NaturalLanguage
//
//struct LocalAnalysisResult {
//    let summary: String
//    let keywords: [String]
//}
//
//final class LocalAnalysisService {
//
//    private static let stopWords: Set<String> = [
//        "и", "в", "во", "не", "что", "он", "на", "я", "с", "со", "как", "а", "то", "все", "она", "так", "его",
//        "но", "да", "ты", "к", "у", "же", "вы", "за", "бы", "по", "только", "ее", "мне", "было", "вот", "от",
//        "меня", "еще", "нет", "о", "из", "ему", "теперь", "когда", "даже", "ну", "вдруг", "ли", "если", "уже",
//        "или", "ни", "быть", "был", "него", "до", "вас", "нибудь", "опять", "уж", "вам", "ведь", "там", "потом",
//        "себя", "ничего", "ей", "может", "они", "тут", "где", "есть", "надо", "ней", "для", "мы", "тебя", "их",
//        "чем", "была", "сам", "чтоб", "без", "будто", "чего", "раз", "тоже", "себе", "под", "будет", "ж", "тогда",
//        "кто", "этот"
//    ]
//
//    static func analyze(text: String) -> LocalAnalysisResult {
//        let sentences = splitIntoSentences(text)
//        let keywords = extractKeywords(from: text)
//        let lemmatizedKeywords = keywords.map { lemmatize($0) }
//
//        let ranked = rankSentences(sentences, keywords: Set(lemmatizedKeywords))
//        let topSentences = ranked
//            .sorted { $0.score > $1.score }
//            .prefix(3)
//            .map { $0.sentence }
//
//        let summarySentences = sentences.filter { topSentences.contains($0) }
//        let cleanedSummary = removeSimilarSentences(from: summarySentences)
//            .joined(separator: "\n\n")
//
//        return LocalAnalysisResult(
//            summary: cleanedSummary,
//            keywords: Array(Set(lemmatizedKeywords)).prefix(10).map { $0 }
//        )
//    }
//
//    // MARK: - Helpers
//
//    private static func splitIntoSentences(_ text: String) -> [String] {
//        var sentences: [String] = []
//        let tokenizer = NLTokenizer(unit: .sentence)
//        tokenizer.string = text
//        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
//            let sentence = String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
//            if !sentence.isEmpty {
//                sentences.append(sentence)
//            }
//            return true
//        }
//        return sentences
//    }
//
//    private static func extractKeywords(from text: String) -> [String] {
//        var keywords: [String] = []
//
//        let tagger = NLTagger(tagSchemes: [.lexicalClass, .lemma])
//        tagger.string = text
//
//        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
//
//        tagger.enumerateTags(in: text.startIndex..<text.endIndex,
//                             unit: .word,
//                             scheme: .lexicalClass,
//                             options: options) { tag, range in
//            guard tag == .noun || tag == .verb else { return true }
//
//            let word = String(text[range]).lowercased()
//            let lemma = lemmatize(word)
//
//            if !stopWords.contains(lemma) {
//                keywords.append(lemma)
//            }
//            return true
//        }
//
//        return keywords
//    }
//
//    private static func lemmatize(_ word: String) -> String {
//        let tagger = NLTagger(tagSchemes: [.lemma])
//        tagger.string = word
//
//        let range = word.startIndex..<word.endIndex
//        let lemma = tagger.tag(at: word.startIndex, unit: .word, scheme: .lemma).0?.rawValue
//
//        return lemma?.lowercased() ?? word.lowercased()
//    }
//
//    private static func rankSentences(_ sentences: [String], keywords: Set<String>) -> [(sentence: String, score: Int)] {
//        return sentences.map { sentence in
//            let words = sentence.lowercased().components(separatedBy: CharacterSet.alphanumerics.inverted)
//            let lemmas = words.map { lemmatize($0) }
//            let score = lemmas.filter { keywords.contains($0) }.count
//            return (sentence: sentence, score: score)
//        }
//    }
//
//    private static func removeSimilarSentences(from sentences: [String]) -> [String] {
//        var result: [String] = []
//
//        for sentence in sentences {
//            if !result.contains(where: { isSimilar($0, sentence) }) {
//                result.append(sentence)
//            }
//        }
//
//        return result
//    }
//
//    private static func isSimilar(_ lhs: String, _ rhs: String) -> Bool {
//        let lhsWords = Set(lhs.lowercased().split(separator: " "))
//        let rhsWords = Set(rhs.lowercased().split(separator: " "))
//        let intersection = lhsWords.intersection(rhsWords)
//        let ratio = Double(intersection.count) / Double(min(lhsWords.count, rhsWords.count))
//        return ratio > 0.8
//    }
//}

import Foundation

struct LocalAnalysisResult {
    let summary: String
    let keywords: [String]
}

final class LocalAnalysisService {
    private static let stopWords: Set<String> = [
        "и", "в", "во", "не", "что", "он", "на", "я", "с", "со", "как", "а", "то", "все", "она", "так", "его",
        "но", "да", "ты", "к", "у", "же", "вы", "за", "бы", "по", "только", "ее", "мне", "было", "вот", "от",
        "меня", "еще", "нет", "о", "из", "ему", "теперь", "когда", "даже", "ну", "вдруг", "ли", "если", "уже",
        "или", "ни", "быть", "был", "него", "до", "вас", "нибудь", "опять", "уж", "вам", "ведь", "там", "потом",
        "себя", "ничего", "ей", "может", "они", "тут", "где", "есть", "надо", "ней", "для", "мы", "тебя", "их",
        "чем", "была", "сам", "чтоб", "без", "будто", "чего", "раз", "тоже", "себе", "под", "будет", "ж", "тогда",
        "кто", "этот", "это", "ее", "её", "никогда", "никому", "никогда не"
    ]

    static func analyze(text: String, completion: @escaping (LocalAnalysisResult) -> Void) {
        LemmatizerService.shared.lemmatize(text: text) { lemmas in
            let wordCounts = Dictionary(grouping: lemmas, by: { $0 }).mapValues { $0.count }

            let sortedKeywords = wordCounts
                .filter { !$0.key.isEmpty }
                .sorted { $0.value > $1.value }
                .map { $0.key }

            let filtered = sortedKeywords.filter { !stopWords.contains($0) }

            let summary = summarize(text: text)
            let result = LocalAnalysisResult(summary: summary, keywords: Array(filtered.prefix(10)))
            completion(result)
        }
    }

    private static func summarize(text: String) -> String {
        let sentences = text.components(separatedBy: ".").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        return sentences.prefix(3).joined(separator: ". ") + (sentences.count > 2 ? "..." : "")
    }
}

