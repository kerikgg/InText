//import SwiftUI
//
//struct BookDetailView: View {
//    let book: BookModel
//
//    @StateObject private var viewModel: TextsViewModel
//    @State private var showAddText = false
//
//    init(book: BookModel) {
//        self.book = book
//        _viewModel = StateObject(wrappedValue: TextsViewModel(bookId: book.id))
//    }
//
//    var body: some View {
//        VStack {
//            if viewModel.texts.isEmpty {
//                Spacer()
//                Text("Нет отрывков")
//                    .foregroundColor(.gray)
//                Spacer()
//            } else {
//                List {
//                    ForEach(viewModel.texts) { text in
//                        NavigationLink(destination: TextDetailView(text: text, allowSaving: false)) {
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text(text.title)
//                                    .font(.headline)
//                                Text(text.createdAt.formatted(.dateTime.locale(Locale(identifier: "ru_RU"))))
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
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
//        .navigationTitle(book.title)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    showAddText = true
//                } label: {
//                    Image(systemName: "plus")
//                }
//            }
//        }
//        .sheet(isPresented: $showAddText, onDismiss: {
//            viewModel.fetchTexts()
//        }) {
//            AddTextView(bookId: book.id)
//        }
//        .onAppear {
//            viewModel.fetchTexts()
//        }
//    }
//}
//

import SwiftUI

struct BookDetailView: View {
    let book: BookModel

    @StateObject private var viewModel: TextsViewModel
    @State private var showAddText = false
    @State private var sortDescending = true

    var sortedTexts: [TextModel] {
        viewModel.texts.sorted {
            sortDescending ? $0.createdAt > $1.createdAt : $0.createdAt < $1.createdAt
        }
    }

    init(book: BookModel) {
        self.book = book
        _viewModel = StateObject(wrappedValue: TextsViewModel(bookId: book.id))
    }

    var body: some View {
        VStack {
            if viewModel.texts.isEmpty {
                Spacer()
                Text("Нет отрывков")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(sortedTexts) { text in
                        NavigationLink(destination: TextDetailView(text: text, allowSaving: false)) {
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
                            let text = sortedTexts[index]
                            viewModel.deleteText(text)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(book.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        sortDescending.toggle()
                    } label: {
                        //Image(systemName: sortDescending ? "arrow.down" : "arrow.up")
                        Image(systemName: "arrow.up.arrow.down")
                    }

                    Button {
                        showAddText = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddText, onDismiss: {
            viewModel.fetchTexts()
        }) {
            AddTextView(bookId: book.id)
        }
        .onAppear {
            viewModel.fetchTexts()
        }
    }
}

