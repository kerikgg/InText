//import SwiftUI
//
//struct ProfileView: View {
//    @StateObject private var viewModel = ProfileViewModel()
//    @State private var showSettings = false
//    @State private var showAvatarPicker = false
//    @State private var showChangeAvatarAlert = false
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Spacer().frame(height: 40)
//
//            Group {
//                Button {
//                    showChangeAvatarAlert = true
//                } label: {
//                    if let url = viewModel.user?.photoURL {
//                        AsyncImage(url: url) { image in
//                            image.resizable()
//                        } placeholder: {
//                            ProgressView()
//                        }
//                        .frame(width: 100, height: 100)
//                        .clipShape(Circle())
//                    } else {
//                        Image(systemName: "person.circle.fill")
//                            .resizable()
//                            .frame(width: 100, height: 100)
//                            .foregroundColor(.purple.opacity(0.8))
//                    }
//                }
//                .buttonStyle(PlainButtonStyle())
//            }
//
//            // Имя и почта
//            VStack(spacing: 4) {
//                Text(viewModel.user?.name ?? "Имя не указано")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                    .fontDesign(.rounded)
//                Text(viewModel.user?.email ?? "Email отсутствует")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//
//            Spacer()
//        }
//        .padding()
//        .navigationTitle("Профиль")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                SettingsButton {
//                    showSettings = true
//                }
//            }
//        }
//        .sheet(isPresented: $showSettings) {
//            SettingsView(viewModel: viewModel)
//        }
//        .alert("Изменить аватар?", isPresented: $showChangeAvatarAlert) {
//            Button("Да", role: .none) {
//                showAvatarPicker = true
//            }
//            Button("Отмена", role: .cancel) {}
//        } message: {
//            Text("Вы хотите выбрать новый аватар из галереи?")
//        }
//        .sheet(isPresented: $showAvatarPicker) {
//            AvatarPickerView(viewModel: viewModel)
//        }
//    }
//}
//


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
