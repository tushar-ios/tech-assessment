import Combine
import SwiftData

/// Access point for all needs related to products
public protocol ProductsService: LocalProductsService, RemoteProductsService {
    var defaultProductsFetchLimit: Int { get }
}

/// Impl of the `ProductsService` which is a composition of `LocalProductsService` and `RemoteProductsService`
public struct ProductsServiceImpl: ProductsService {
    public let defaultProductsFetchLimit = 20
    fileprivate let localProductsServiceDependencies: LocalProductsServiceDependencies
    
    public init(localProductsServiceDependencies: LocalProductsServiceDependencies) {
        self.localProductsServiceDependencies = localProductsServiceDependencies
    }
}

/// Extension holding `LocalProductsService` related methods
extension ProductsServiceImpl {
    private var productsChangeSubject: PassthroughSubject<(), Never> {
        localProductsServiceDependencies.productsChangeSubject
    }
    
    private var localProductsActor: LocalProductsActor {
        localProductsServiceDependencies.localProductsActor
    }
    
    public var localProductsChangePublisher: AnyPublisher<(), Never> {
        productsChangeSubject.eraseToAnyPublisher()
    }
    
    public func localProductsTotalCount() async throws -> Int {
        try await localProductsActor.productsTotalCount()
    }
    
    public func fetchLocalProducts(_ dependencies: LocalProductsFetchDependencies) async throws -> [Product] {
        let sortDescriptor = dependencies.sortOrder.mapToProductModelSortDescriptor()
        var fetchDescriptor = FetchDescriptor<ProductModel>(sortBy: [sortDescriptor])
        fetchDescriptor.fetchLimit = dependencies.fetchLimit
        fetchDescriptor.fetchOffset = dependencies.fetchOffset
        return try await localProductsActor.fetchProducts(fetchDescriptor)
    }
    
    public func createAndSaveProductLocally(_ product: Product) async throws {
        let productModel = product.mapToProductModel()
        try await localProductsActor.createAndSaveProduct(productModel)
        productsChangeSubject.send()
    }
}
