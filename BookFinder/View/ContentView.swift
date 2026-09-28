import SwiftUI

struct ContentView: View {
    @State private var viewModel: BookViewModel
    @State private var searchBook = ""
    @State private var searchTask: Task<Void, Never>?
    init(service: BookServiceProtocol) {
        _viewModel = State(
            initialValue: BookViewModel(bookFinderService: service)
        )
    }
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Введите название книги", text: $searchBook)
                    .padding()
                Button("Поиск") {
                    searchTask?.cancel()
                    searchTask = Task {
                        await viewModel.searchBooks(query: searchBook)
                    }
                }
                if let error = viewModel.errorMessage {
                    Text(error)
                        .padding(.top)
                        .foregroundStyle(.red)
                        .bold()
                }
                List {
                    ForEach(viewModel.books, id: \.key) { book in
                        VStack(alignment: .leading, spacing: 20) {
                            Text(book.title)
                            if let year = book.year {
                                Text("Год издания \(String(year))")
                            }
                        }
                    }

                }
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
                
                .navigationTitle("Библиотека")
            }
        }
        .onDisappear {
            searchTask?.cancel()
        }
    }
}

#Preview {
    ContentView(service: BookService())
}
