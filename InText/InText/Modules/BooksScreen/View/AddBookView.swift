//import SwiftUI
//
//struct AddBookView: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject private var viewModel = AddBookViewModel()
//    @State private var selectedType: SourceType = .book
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//                Picker("Тип источника", selection: $selectedType) {
//                    ForEach(SourceType.allCases) { type in
//                        Text(type.rawValue).tag(type)
//                    }
//                }
//                .pickerStyle(.segmented)
//
//                TextField("Название книги", text: $viewModel.title)
//                    .textFieldStyle(.roundedBorder)
//                    .padding(.horizontal)
//
//                Button("Сохранить") {
//                    viewModel.save()
//                    dismiss()
//                }
//                .buttonStyle(MainActionButtonStyle())
//                .padding()
//
//                Spacer()
//            }
//            .navigationTitle("Новая книга")
//            .alert("Введите название книги", isPresented: $viewModel.showAlert) {
//                Button("OK", role: .cancel) { }
//            }
//        }
//    }
//}
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AddBookViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Информация")) {
                    CustomTextField(title: "Название", text: $viewModel.title)
                    CustomTextField(title: "Автор", text: $viewModel.author)
//                    TextField("Название", text: $viewModel.title)
//                    TextField("Автор", text: $viewModel.author)

                    Picker("Тип источника", selection: $viewModel.sourceType) {
                        ForEach(SourceType.allCases, id: \.self) { type in
                            Text(type.localizedName).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section {
                    Button {
                        viewModel.save()
                        dismiss()
                    } label: {
                        ZStack {
                            if viewModel.canSubmit {
                                AnimatedGradient(colors: [Color.purple, Color.blue])
                            } else {
                                Rectangle()
                                    .foregroundColor(.gray)
                            }

                            Text("Сохранить")
                                .foregroundColor(.white)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                        }
                        .cornerRadius(10)
                    }
                    .disabled(!viewModel.canSubmit)
                }
            }
            .navigationTitle("Новый источник")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }

        }
    }
}

//                Section {

                    //                    Button("Сохранить") {
                    //                        viewModel.save()
                    //                        dismiss()
                    //                    }
                    //                    .disabled(!viewModel.canSubmit)
//                }
