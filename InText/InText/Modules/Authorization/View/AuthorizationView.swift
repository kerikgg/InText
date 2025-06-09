//
//  AuthorizationView.swift
//  InText
//
//  Created by kerik on 28.05.2025.
//

import SwiftUI

struct AuthorizationView: View {
    @StateObject private var viewModel = AuthorizationViewModel()
    @Binding var showLogin: Bool

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                Image("ReadingBoy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width / 1.5)

                Text("Вход")
                    .font(.title)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .padding(8)

                VStack(spacing: 20) {
                    CustomTextField(title: "Почта", text: $viewModel.email)

                    CustomTextField(title: "Пароль", text: $viewModel.password, isSecure: true)
                }
                .padding()

                Button {
                    viewModel.loginUser()
                } label: {
                    ZStack {
                        if viewModel.canSubmit {
                            AnimatedGradient(colors: [Color.purple, Color.blue])
                        } else {
                            Rectangle()
                                .foregroundColor(.gray)
                        }

                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Войти")
                                .foregroundColor(.white)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(width: 160, height: 45)
                    .cornerRadius(10)
                }
                .disabled(!viewModel.canSubmit || viewModel.isLoading)

                Button("Нет аккаунта? Зарегистрироваться") {
                    showLogin = false
                }
                .font(.footnote)
                .foregroundColor(.blue)

                if viewModel.loginSuccess {
                    Text("Успешный вход!")
                        .foregroundColor(.green)
                        .font(.headline)
                        .padding()
                }
            }
            .padding()
        }
        .scrollDisabled(true)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Ошибка входа"),
                message: Text(viewModel.loginError ?? "Неизвестная ошибка."),
                dismissButton: .default(Text("ОК"))
            )
        }
    }
}

