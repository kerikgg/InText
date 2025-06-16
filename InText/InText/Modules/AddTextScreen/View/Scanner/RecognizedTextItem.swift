import Foundation

struct RecognizedTextItem: Identifiable {
    let id = UUID()
    let text: String
    var isSelected: Bool = true
}
