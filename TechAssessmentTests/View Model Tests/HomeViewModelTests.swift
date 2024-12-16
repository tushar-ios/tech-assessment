import ProductsService
import Testing
@testable import TechAssessment

struct HomeViewModelTests {
    private let productsService: ProductsService
    private let sut: HomeView.ViewModel
    
    init() {
        self.productsService = ProductsServiceImpl(
            localProductsServiceDependencies: .init(
                inMemoryStorage: true
            )
        )
        self.sut = HomeView.ViewModel(productsService: self.productsService)
    }
    
    @Test
    func viewModelDefaultState() {
        #expect(sut.sortOrder == .byName)
    }
}
