import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Профиль")) {
                    NavigationLink("Изменить аватар") {
                        AvatarPickerView(viewModel: viewModel)
                    }
                }

                Section(header: Text("Настройки")) {
                    Toggle("Тёмная тема", isOn: $viewModel.isDarkMode)
                }

                Section {
                    Button("Удалить аккаунт", role: .destructive) {
                        viewModel.showDeleteAlert = true
                    }

                    Button("Выйти", role: .destructive) {
                        showLogoutAlert = true
                    }
                }
            }
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Удалить аккаунт?", isPresented: $viewModel.showDeleteAlert) {
                Button("Удалить", role: .destructive) {
                    viewModel.deleteAccount()
                }
                Button("Отмена", role: .cancel) {}
            } message: {
                Text("Это действие необратимо.")
            }
            .alert("Выйти из аккаунта?", isPresented: $showLogoutAlert) {
                Button("Выйти", role: .destructive) {
                    viewModel.logout()
                }
                Button("Отмена", role: .cancel) {}
            } message: {
                Text("Вы уверены, что хотите выйти?")
            }
        }
    }
    //    var body: some View {
    //        NavigationView {
    //            VStack(spacing: 30) {
    //                Toggle("Тёмная тема", isOn: $viewModel.isDarkMode)
    //                    .padding(.horizontal)
    //
    //                Button("Удалить аккаунт", role: .destructive) {
    //                    viewModel.showDeleteAlert = true
    //                }
    //
    //                Button("Выйти", role: .destructive) {
    //                    showLogoutAlert = true
    //                }
    //
    //                Spacer()
    //            }
    //            .padding()
    //            .navigationTitle("Настройки")
    //            .navigationBarTitleDisplayMode(.inline)
    //            .alert("Удалить аккаунт?", isPresented: $viewModel.showDeleteAlert) {
    //                Button("Удалить", role: .destructive) {
    //                    viewModel.deleteAccount()
    //                }
    //                Button("Отмена", role: .cancel) {}
    //            } message: {
    //                Text("Это действие необратимо.")
    //            }
    //            .alert("Выйти из аккаунта?", isPresented: $showLogoutAlert) {
    //                Button("Выйти", role: .destructive) {
    //                    viewModel.logout()
    //                }
    //                Button("Отмена", role: .cancel) {}
    //            } message: {
    //                Text("Вы уверены, что хотите выйти?")
    //            }
    //        }
    //    }
}

