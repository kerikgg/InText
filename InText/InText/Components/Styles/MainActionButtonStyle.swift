import SwiftUI

struct MainActionButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(configuration.isPressed ? color.opacity(0.7) : color)
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}
