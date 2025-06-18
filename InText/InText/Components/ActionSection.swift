import SwiftUI

struct ActionSection: View {
    let title: String
    let description: String
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: action) {
                Text(title)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(MainActionButtonStyle(color: .purple))

            HStack {
                Spacer()
                Text(description)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
                Spacer()
            }

        }
    }
}

