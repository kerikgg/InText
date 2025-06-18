//import SwiftUI
//
//struct ProfileView: View {
//    @StateObject private var viewModel = ProfileViewModel()
//    @StateObject private var statsViewModel = ProfileStatsViewModel()
//    @State private var showSettings = false
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Spacer().frame(height: 40)
//
//            ProfileAvatarView(viewModel: viewModel)
//
//            if let user = viewModel.user {
//                ProfileInfoView(name: user.name, email: user.email)
//            }
//
//            Section(header: Text("Статистика").font(.headline)) {
//                StatItemView(emoji: "📚", label: "Прочитано книг / статей", value: "\(stats.totalBooks) книг, \(stats.totalArticles) статей")
//                StatItemView(emoji: "✍️", label: "Добавлено отрывков", value: "\(stats.totalTexts)")
//                StatItemView(emoji: "🧠", label: "Проанализировано текстов", value: "\(stats.analyzedTexts)")
//                StatItemView(emoji: "🔑", label: "Уникальных ключевых слов", value: "\(stats.uniqueKeywords)")
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
//        .onAppear {
//            statsViewModel.loadStats()
//        }
//    }
//}

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @StateObject private var stats = ProfileStatsViewModel()
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ProfileAvatarView(viewModel: viewModel)

                if let user = viewModel.user {
                    ProfileInfoView(name: user.name, email: user.email)
                }

                StatsView(stats: stats)

                Spacer()
            }
            .padding()
            //.toolbarBackgroundVisibility(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Профиль")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showSettings, onDismiss: {
                stats.loadStats()
            }) {
                SettingsView(viewModel: viewModel)
            }
            .onAppear {
                stats.loadStats()
            }
        }
    }
}
//import SwiftUI
//
//struct ProfileView: View {
//    @StateObject private var viewModel = ProfileViewModel()
//    @StateObject private var stats = ProfileStatsViewModel()
//    @State private var showSettings = false
//
//    var body: some View {
//        VStack(spacing: 20) {
//            ProfileAvatarView(viewModel: viewModel)
//
//            if let user = viewModel.user {
//                ProfileInfoView(name: user.name, email: user.email)
//            }
//
//            StatsView(stats: stats)
//
//            Spacer()
//        }
//        .padding()
//        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationTitle("Профиль")
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    showSettings = true
//                } label: {
//                    Image(systemName: "gearshape.fill")
//                        .imageScale(.large)
//                }
//            }
//        }
//        .sheet(isPresented: $showSettings, onDismiss: {
//            stats.loadStats()
//        }) {
//            SettingsView(viewModel: viewModel)
//        }
//        .onAppear {
//            stats.loadStats()
//        }
//    }
//}
