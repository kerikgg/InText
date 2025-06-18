import Foundation

struct IdentifiableText: Identifiable {
    let id = UUID()
    let text: String
}
