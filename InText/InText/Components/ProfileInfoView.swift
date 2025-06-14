import SwiftUI

struct ProfileInfoView: View {
    let name: String
    let email: String

    var body: some View {
        VStack(spacing: 4) {
            Text(name)
                .font(.title2)
                .fontWeight(.semibold)
                .fontDesign(.rounded)

            Text(email)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
