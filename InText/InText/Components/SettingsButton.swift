import SwiftUI

struct SettingsButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "gearshape.fill")
                .imageScale(.large)
                .foregroundColor(.primary)
        }
    }
}
