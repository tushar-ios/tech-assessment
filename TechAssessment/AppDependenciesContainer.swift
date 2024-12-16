import ProductsService

/// Access point for all app level dependencies
protocol AppDependenciesProvider {
    var productsService: ProductsService { get }
}

/// Container for app dependencies using constructor injection
struct AppDependenciesContainer: AppDependenciesProvider {
    let productsService: ProductsService = {
        ProductsServiceImpl(
            localProductsServiceDependencies: .init(
                inMemoryStorage: false
            )
        )
    }()
}
