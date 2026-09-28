import Testing

@testable import BookFinder

@MainActor
struct BookFinderTests {

    @Test
    func searchBooksSuccess() async {

        let service = MockBookService()
        let viewModel = BookViewModel(
            bookFinderService: service
        )

        await viewModel.searchBooks(query: "Гарри")

        let book = viewModel.books.first

        #expect(service.receivedQuery == "Гарри")
        #expect(book?.key == "001-1")
        #expect(book?.title == "Гарри Поттер")
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func searchBooksFailure() async {

        let service = MockBookService()
        let viewModel = BookViewModel(
            bookFinderService: service
        )

        service.shouldFail = true

        await viewModel.searchBooks(query: "Гарри")

        #expect(service.receivedQuery == "Гарри")
        #expect(viewModel.errorMessage == "Код ошибки: 500")
    }

    @Test
    func searchBooksRecoveryAfterFailure() async {

        let service = MockBookService()
        let viewModel = BookViewModel(
            bookFinderService: service
        )

        service.shouldFail = true

        await viewModel.searchBooks(query: "Гарри")

        #expect(viewModel.errorMessage == "Код ошибки: 500")

        service.shouldFail = false

        await viewModel.searchBooks(query: "Гарри")

        let book = viewModel.books.first

        #expect(viewModel.errorMessage == nil)
        #expect(book?.key == "001-1")
        #expect(book?.title == "Гарри Поттер")
    }

    @Test
    func loadingState() async {

        let service = MockBookService()
        let viewModel = BookViewModel(
            bookFinderService: service
        )
        let task = Task {
            await viewModel.searchBooks(query: "Гарри")
        }

        await Task.yield()
        #expect(viewModel.isLoading == true)

        await task.value

        #expect(viewModel.isLoading == false)
    }

    @Test
    func cancelTask() async {
        let service = MockBookService()
        let viewModel = BookViewModel(
            bookFinderService: service
        )

        let task = Task {
            await viewModel.searchBooks(query: "Гарри")
        }

        await Task.yield()

        task.cancel()

        await task.value

        #expect(viewModel.books.isEmpty)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
    }
}
