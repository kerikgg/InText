import SwiftUI

struct MainActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(configuration.isPressed ? Color.purple.opacity(0.7) : Color.purple)
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}
