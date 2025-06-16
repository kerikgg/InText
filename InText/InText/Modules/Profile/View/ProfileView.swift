import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)

            ProfileAvatarView(viewModel: viewModel)

            if let user = viewModel.user {
                ProfileInfoView(name: user.name, email: user.email)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Профиль")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                SettingsButton {
                    showSettings = true
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: viewModel)
        }
    }
}
