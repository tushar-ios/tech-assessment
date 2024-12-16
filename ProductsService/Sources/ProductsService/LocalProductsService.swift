import Combine
import SwiftData

/// Access point for all needs related to local storage products
public protocol LocalProductsService {
    var localProductsChangePublisher: AnyPublisher<(), Never> { get }
    func localProductsTotalCount() async throws -> Int
    func fetchLocalProducts(_ dependencies: LocalProductsFetchDependencies) async throws -> [Product]
    func createAndSaveProductLocally(_ product: Product) async throws
}

/// Data transfer object holding dependencies required to perform a local products fetch
public struct LocalProductsFetchDependencies {
    let fetchLimit: Int
    let fetchOffset: Int
    let sortOrder: ProductsSortOrder
    
    public init(
        fetchLimit: Int,
        fetchOffset: Int,
        sortOrder: ProductsSortOrder
    ) {
        self.fetchLimit = fetchLimit
        self.fetchOffset = fetchOffset
        self.sortOrder = sortOrder
    }
}

/// Data transfer object holding dependencies required by local products service
public struct LocalProductsServiceDependencies {
    let localProductsActor: LocalProductsActor
    let productsChangeSubject: PassthroughSubject<(), Never> = .init()
    
    public init(inMemoryStorage: Bool) {
        var cmdInMemoryStorage: Bool = false
        #if DEBUG
        if CommandLine.arguments.contains("in-memory-storage-mode") {
            cmdInMemoryStorage = true
        }
        #endif
        let modelContainer: ModelContainer = cmdInMemoryStorage || inMemoryStorage ? .inMemoryModelContainer : .persistedModelContainer
        self.localProductsActor = LocalProductsActor(modelContainer: modelContainer)
    }
}
