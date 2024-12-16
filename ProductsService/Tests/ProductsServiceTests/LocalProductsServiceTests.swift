import Combine
import Testing
@testable import ProductsService

final class LocalProductsServiceTests {
    private let sut: LocalProductsService
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.sut = ProductsServiceImpl(localProductsServiceDependencies: .init(inMemoryStorage: true))
    }
    
    @Test
    func fetchLocalProductsPublisherReceivesEvent() async throws {
        try await confirmation { confirmation in
            sut.localProductsChangePublisher.sink { _ in
                confirmation()
            }.store(in: &self.cancellables)
            _ = try await sut.createAndSaveProductLocally(.init(name: "Product"))
        }
    }
    
    @Test
    func fetchLocalProductsWithCorrectSortOrder() async throws {
        try await sut.createAndSaveProductLocally(.init(name: "Product 2"))
        try await sut.createAndSaveProductLocally(.init(name: "Product 1"))
        
        var products = try await sut.fetchLocalProducts(.init(fetchLimit: 10, fetchOffset: 0, sortOrder: .byName))
        #expect(products.count == 2)
        #expect(products[0].name == "Product 1")
        #expect(products[1].name == "Product 2")
        
        products = try await sut.fetchLocalProducts(.init(fetchLimit: 10, fetchOffset: 0, sortOrder: .byDate))
        #expect(products.count == 2)
        #expect(products[0].name == "Product 2")
        #expect(products[1].name == "Product 1")
    }
    
    @Test
    func createAndSaveProductLocally() async throws {
        try await sut.createAndSaveProductLocally(.init(name: "Product"))
        
        let products = try await sut.fetchLocalProducts(.init(fetchLimit: 10, fetchOffset: 0, sortOrder: .byName))
        #expect(products.count == 1)
        #expect(products[0].name == "Product")
    }
    
    @Test
    func fetchLocalProductsCount() async throws {
        try await sut.createAndSaveProductLocally(.init(name: "Product 1"))
        try await sut.createAndSaveProductLocally(.init(name: "Product 2"))
        
        let count = try await sut.localProductsTotalCount()
        #expect(count == 2)
    }
    
    @Test
    func fetchLocalProductsWithCorrectFetchLimit() async throws {
        try await sut.createAndSaveProductLocally(.init(name: "Product 1"))
        try await sut.createAndSaveProductLocally(.init(name: "Product 2"))
        
        let products = try await sut.fetchLocalProducts(.init(fetchLimit: 1, fetchOffset: 0, sortOrder: .byName))
        #expect(products.count == 1)
        #expect(products[0].name == "Product 1")
    }
    
    @Test
    func fetchLocalProductsWithCorrectFetchOffset() async throws {
        try await sut.createAndSaveProductLocally(.init(name: "Product 1"))
        try await sut.createAndSaveProductLocally(.init(name: "Product 2"))
        
        let products = try await sut.fetchLocalProducts(.init(fetchLimit: 1, fetchOffset: 1, sortOrder: .byName))
        #expect(products.count == 1)
        #expect(products[0].name == "Product 2")
    }
}
