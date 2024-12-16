import Combine
import Foundation
import Observation
import ProductsService

extension ProductsListView {
    @Observable
    final class ViewModel {
        enum FetchType {
            case initial, refresh, loadMore
        }
        
        private var fetchProductsCountTask: Task<Int, Error>?
        private var fetchProductsTask: Task<[Product], Error>?
        private var fetchProductsExecutorTask: Task<Void, Never>?
        private var cancellables = Set<AnyCancellable>()
        private(set) var products: [Product] = []
        
        var showErrorAlert = false
        
        private let productsService: ProductsService
        var sortOrder: ProductsSortOrder
        
        init(
            productsService: ProductsService,
            sortOrder: ProductsSortOrder
        ) {
            self.productsService = productsService
            self.sortOrder = sortOrder
        }
        
        /// Fetches total count of the products stored locally
        private func fetchProductsCount() async -> Int? {
            fetchProductsCountTask?.cancel()
            fetchProductsCountTask = Task {
                try await productsService.localProductsTotalCount()
            }
            
            let taskResult = await fetchProductsCountTask?.result
            
            do {
                return try taskResult?.get()
            } catch {
                await MainActor.run {
                    showErrorAlert = true
                }
                
                return nil
            }
        }
        
        /// Fetches products stored locally
        /// - Parameters:
        ///   - fetchLimit: Limit of the number of products needed to be fetched
        ///   - fetchOffset: Offset of where the fetch should begin from
        private func fetchProducts(fetchLimit: Int, fetchOffset: Int) async -> [Product]? {
            fetchProductsTask?.cancel()
            fetchProductsTask = Task {
                let dependencies = LocalProductsFetchDependencies(
                    fetchLimit: fetchLimit,
                    fetchOffset: fetchOffset,
                    sortOrder: sortOrder
                )
                return try await productsService.fetchLocalProducts(dependencies)
            }
            
            let taskResult = await fetchProductsTask?.result
            
            do {
                return try taskResult?.get()
            } catch {
                await MainActor.run {
                    showErrorAlert = true
                }
                
                return nil
            }
        }
        
        /// Subscribe to local products changes
        func subscribeToLocalProductsChangePublisher() {
            productsService
                .localProductsChangePublisher
                .sink { [weak self] in
                    guard let self else { return }
                    fetchProducts(.refresh)
                }
                .store(in: &cancellables)
        }
        
        /// Fetches more products if current product being shown is the last product in list
        /// - Parameter product: Current product being shown in the list
        func fetchNextProductsAfter(_ product: Product) {
            guard products.last == product else { return }
            fetchProducts(.loadMore)
        }
        
        /// Fetches products depending on fetch type
        /// - Parameter fetchType: type of the fetch
        func fetchProducts(_ fetchType: FetchType) {
            fetchProductsExecutorTask?.cancel()
            fetchProductsExecutorTask = Task {
                switch fetchType {
                case .initial, .refresh:
                    let defaultLimit = productsService.defaultProductsFetchLimit
                    let fetchLimit = fetchType == .initial ? defaultLimit : max(defaultLimit, products.count)
                    guard let fetchedProducts = await fetchProducts(
                        fetchLimit: fetchLimit,
                        fetchOffset: 0
                    ) else {
                        return
                    }
                    
                    await MainActor.run {
                        products = fetchedProducts
                    }
                case .loadMore:
                    guard let fetchedProducts = await fetchProducts(
                        fetchLimit: productsService.defaultProductsFetchLimit,
                        fetchOffset: products.count
                    ) else {
                        return
                    }
                    
                    await MainActor.run {
                        products.append(contentsOf: fetchedProducts)
                    }
                }
            }
        }
    }
}
