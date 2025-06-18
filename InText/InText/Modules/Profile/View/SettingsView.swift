import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showLogoutAlert = false
    @State private var deletionCompleted = false
    @EnvironmentObject var themeService: AppThemeService

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Настройки")) {
                    Toggle("Тёмная тема", isOn: $themeService.isDarkMode)
                }

                Section {
                    Button("Удалить все данные", role: .destructive) {
                        viewModel.showDeleteAllDataAlert = true
                    }

                    Button("Удалить аккаунт", role: .destructive) {
                        viewModel.showDeleteAlert = true
                    }

                    Button("Выйти", role: .destructive) {
                        showLogoutAlert = true
                    }
                }
            }
            .preferredColorScheme(themeService.isDarkMode ? .dark : .light)
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
            .alert("Удалить все данные?", isPresented: $viewModel.showDeleteAllDataAlert) {
                Button("Удалить", role: .destructive) {
                    viewModel.deleteAllData()
                }
                Button("Отмена", role: .cancel) {}
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

