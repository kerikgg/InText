import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            BooksView()
                .tabItem {
                    Label("Главная", systemImage: "house")
                }

            TestsView()
                .tabItem {
                    Label("Тесты", systemImage: "questionmark.circle")
                }

            ProfileView()
                .tabItem {
                    Label("Профиль", systemImage: "person.circle")
                }
        }
        .tint(Color.purple)
    }
}
