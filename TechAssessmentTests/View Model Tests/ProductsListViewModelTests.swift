import ProductsService
import Testing
@testable import TechAssessment

final class ProductsListViewModelTests {
    private let productsService: ProductsService
    private let sut: ProductsListView.ViewModel
    
    init() {
        self.productsService = ProductsServiceImpl(
            localProductsServiceDependencies: .init(
                inMemoryStorage: true
            )
        )
        self.sut = ProductsListView.ViewModel(
            productsService: self.productsService,
            sortOrder: .byName
        )
    }
    
    @Test
    func viewModelDefaultState() {
        #expect(sut.products.isEmpty)
        #expect(!sut.showErrorAlert)
        #expect(sut.sortOrder == .byName)
    }
    
    @Test
    func fetchProductsCalledWhenSubscriptionMethodCalled() async throws {
        #expect(sut.products.isEmpty)
        #expect(!sut.showErrorAlert)
        
        sut.subscribeToLocalProductsChangePublisher()
        try await productsService.createAndSaveProductLocally(.init(name: "Product"))
        
        /// Let the save task finish
        try await Task.sleep(for: .seconds(1))
        
        #expect(sut.products.count == 1)
        #expect(!sut.showErrorAlert)
    }
    
    @Test
    func fetchProductsWithInitialFetchState() async throws {
        try await productsService.createAndSaveProductLocally(.init(name: "Product 1"))
        try await productsService.createAndSaveProductLocally(.init(name: "Product 2"))
        
        #expect(sut.products.isEmpty)
        
        sut.fetchProducts(.initial)
        
        /// Let the fetch task finish
        try await Task.sleep(for: .seconds(1))
        
        #expect(sut.products.count == 2)
        #expect(!sut.showErrorAlert)
    }
    
    @Test
    func fetchProductsWithRefreshFetchState() async throws {
        try await productsService.createAndSaveProductLocally(.init(name: "Product 1"))
        try await productsService.createAndSaveProductLocally(.init(name: "Product 2"))
        
        #expect(sut.products.isEmpty)
        
        sut.fetchProducts(.refresh)
        
        /// Let the fetch task finish
        try await Task.sleep(for: .seconds(1))
        
        #expect(sut.products.count == 2)
        #expect(!sut.showErrorAlert)
    }
    
    @Test
    func fetchProductsWithLoadMoreFetchState() async throws {
        try await productsService.createAndSaveProductLocally(.init(name: "Product 1"))
        try await productsService.createAndSaveProductLocally(.init(name: "Product 2"))
        
        #expect(sut.products.isEmpty)
        
        sut.fetchProducts(.loadMore)
        
        /// Let the fetch task finish
        try await Task.sleep(for: .seconds(1))
        
        #expect(sut.products.count == 2)
        #expect(!sut.showErrorAlert)
        
        try await productsService.createAndSaveProductLocally(.init(name: "Product 3"))
        try await productsService.createAndSaveProductLocally(.init(name: "Product 4"))
        
        sut.fetchProducts(.loadMore)
        
        /// Let the fetch task finish
        try await Task.sleep(for: .seconds(1))
        
        #expect(sut.products.count == 4)
        #expect(!sut.showErrorAlert)
    }
    
    @Test
    func fetchNextProducts() async throws {
        try await productsService.createAndSaveProductLocally(.init(name: "Product 1"))
        try await productsService.createAndSaveProductLocally(.init(name: "Product 2"))
        
        #expect(sut.products.isEmpty)
        
        sut.fetchProducts(.initial)
        
        /// Let the fetch task finish
        try await Task.sleep(for: .seconds(1))
        
        #expect(sut.products.count == 2)
        #expect(!sut.showErrorAlert)
        
        try await productsService.createAndSaveProductLocally(.init(name: "Product 3"))
        try await productsService.createAndSaveProductLocally(.init(name: "Product 4"))
        
        sut.fetchNextProductsAfter(sut.products[1])
        
        /// Let the fetch task finish
        try await Task.sleep(for: .seconds(1))
        
        #expect(sut.products.count == 4)
        #expect(!sut.showErrorAlert)
    }
}
