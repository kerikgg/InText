//import SwiftUI
//
//struct StatItemView: View {
//    let title: String
//    let value: String
//
//    var body: some View {
//        VStack {
//            Text(value)
//                .font(.title2)
//                .fontWeight(.bold)
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//        .frame(maxWidth: .infinity)
//    }
//}
//

import SwiftUI

struct StatItemView: View {
    let emoji: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text("\(emoji) \(label)")
                .font(.body)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
    }
}
