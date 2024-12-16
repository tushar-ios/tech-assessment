import Observation
import ProductsService

extension HomeView {
    @Observable
    final class ViewModel {
        let productsService: ProductsService
        var sortOrder: ProductsSortOrder = .byName
        
        init(productsService: ProductsService) {
            self.productsService = productsService
        }
    }
}
