import SwiftUI

struct BookRow: View {
    let book: BookModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(book.title)
                    .font(.headline)

                Spacer()

                Text(book.sourceType.rawValue)
                    .font(.caption)
                    .padding(4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                    .foregroundColor(.blue)
            }

            if let author = book.author, !author.isEmpty {
                Text(author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Text(book.createdAt.formattedString)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
    }
}

