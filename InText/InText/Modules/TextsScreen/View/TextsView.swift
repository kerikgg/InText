//import SwiftUI
//
//struct TextsView: View {
//    @StateObject private var viewModel = TextsViewModel()
//    @State private var showAddText = false
//
//    var body: some View {
//        VStack {
//            if viewModel.texts.isEmpty {
//                Text("У вас пока нет текстов")
//                    .foregroundColor(.gray)
//                    .padding()
//            } else {
//                List {
//                    ForEach(viewModel.texts) { text in
//                        VStack(alignment: .leading) {
//                            Text(text.title)
//                                .font(.headline)
//                            Text(text.createdAt.formatted(date: .abbreviated, time: .shortened))
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            NavigationLink(destination: TextDetailView(text: text)) {
//
//                            }
//                        }
//                    }
//                    .onDelete { indexSet in
//                        indexSet.forEach { index in
//                            let text = viewModel.texts[index]
//                            viewModel.deleteText(text)
//                        }
//                    }
//                }
//                .listStyle(.plain)
//            }
//        }
//        .navigationTitle("Мои тексты")
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    showAddText = true
//                } label: {
//                    Image(systemName: "plus")
//                }
//            }
//        }
//        .sheet(isPresented: $showAddText) {
//            AddTextView()
//        }
//        .onAppear {
//            viewModel.fetchTexts()
//        }
//    }
//}

import SwiftUI

struct TextsView: View {
    let bookId: String
    @StateObject private var viewModel: TextsViewModel

    init(bookId: String) {
        self.bookId = bookId
        _viewModel = StateObject(wrappedValue: TextsViewModel(bookId: bookId))
    }

    @State private var showAddText = false

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.texts.isEmpty {
                    Spacer()
                    Text("Нет сохранённых текстов")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.texts) { text in
                            NavigationLink(destination: TextDetailView(
                                text: text,
                                allowSaving: false
                            )) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(text.title)
                                        .font(.headline)

                                    Text(text.createdAt.formattedString)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let text = viewModel.texts[index]
                                viewModel.deleteText(text)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Мои тексты")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddText = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddText, onDismiss: {
                viewModel.fetchTexts() // обновим после добавления
            }) {
                AddTextView(bookId: bookId)
            }
        }
        .onAppear {
            viewModel.fetchTexts()
        }
    }
}

