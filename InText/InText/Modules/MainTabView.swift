//
//  MainTabView.swift
//  InText
//
//  Created by kerik on 28.05.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Text("Домашняя страница")
                .tabItem {
                    Label("Главная", systemImage: "house")
                }

            Text("Профиль")
                .tabItem {
                    Label("Профиль", systemImage: "person.circle")
                }
        }
    }
}
