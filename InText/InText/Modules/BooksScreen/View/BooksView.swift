//import SwiftUI
//
//struct BooksView: View {
//    @StateObject private var viewModel = BooksViewModel()
//    @State private var showAddBook = false
//
//    var body: some View {
//        NavigationStack {
//            List {
//                Section("Книги") {
//                    ForEach(viewModel.books.filter { $0.sourceType == .book }) { book in
//                        BookRow(book: book)
//                    }
//                    .onDelete(perform: viewModel.deleteBook)
//                }
//
//                Section("Статьи") {
//                    ForEach(viewModel.books.filter { $0.sourceType == .article }) { book in
//                        BookRow(book: book)
//                    }
//                    .onDelete(perform: viewModel.deleteBook)
//                }
//            }
//            .navigationTitle("Мои книги")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        showAddBook = true
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
//            .sheet(isPresented: $showAddBook, onDismiss: {
//                viewModel.fetchBooks()
//            }) {
//                AddBookView()
//            }
//        }
//        .onAppear {
//            viewModel.fetchBooks()
//        }
//    }
//}
//

import SwiftUI

struct BooksView: View {
    @StateObject private var viewModel = BooksViewModel()
    @State private var showAddBook = false

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.books.isEmpty && viewModel.articles.isEmpty {
                    VStack {
                        Text("У вас пока нет книг или статей")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        if !viewModel.books.isEmpty {
                            Section(header: Text("Книги")) {
                                ForEach(viewModel.books) { book in
                                    NavigationLink(destination: BookDetailView(book: book)) {
                                        BookRow(book: book)
                                    }
                                }
                                .onDelete { indexSet in
                                    indexSet.forEach { index in
                                        let book = viewModel.books[index]
                                        viewModel.deleteBook(book)
                                    }
                                }
                            }
                        }

                        if !viewModel.articles.isEmpty {
                            Section(header: Text("Статьи")) {
                                ForEach(viewModel.articles) { article in
                                    NavigationLink(destination: BookDetailView(book: article)) {
                                        BookRow(book: article)
                                    }
                                }
                                .onDelete { indexSet in
                                    indexSet.forEach { index in
                                        let article = viewModel.articles[index]
                                        viewModel.deleteBook(article)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            //.toolbarBackgroundVisibility(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Библиотека")
            .onAppear {
                viewModel.fetchBooks()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddBook = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddBook, onDismiss: {
                viewModel.fetchBooks()
            }) {
                AddBookView()
            }
        }
    }

    //        NavigationStack {
    //
    //        }
}
