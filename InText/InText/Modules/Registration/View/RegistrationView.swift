import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            Image("ReadingBoy")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width / 1.25, height: UIScreen.main.bounds.width / 1.25)

            VStack(spacing: 30) {

                Text("Регистрация")
                    .font(.title)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .padding(8)

                VStack(spacing: 20) {
                    CustomTextField(title: "Имя пользователя", text: $viewModel.name, prompt: viewModel.namePrompt)

                    CustomTextField(title: "Почта", text: $viewModel.email, prompt: viewModel.emailPrompt)

                    CustomTextField(title: "Пароль", text: $viewModel.password, prompt: viewModel.passwordPrompt, isSecure: true)
                }
                .padding()

                Button {
                    viewModel.registerUser()
                } label: {
                    ZStack {
                        if viewModel.canSubmit {
                            AnimatedGradient(colors: [Color.cyan, Color.purple])
                        } else {
                            Rectangle()
                                .foregroundColor(.gray)
                        }

                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Продолжить")
                                .foregroundColor(.white)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(width: 160, height: 45)
                    .cornerRadius(10)
                }
                .disabled(!viewModel.canSubmit || viewModel.isLoading)
            }

        }
        .scrollDisabled(true)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Ошибка регистрации"),
                message: Text(viewModel.registrationError ?? "Неизвестная ошибка."),
                dismissButton: .default(Text("ОК"))
            )
        }
    }
}

#Preview {
    RegistrationView()
}
