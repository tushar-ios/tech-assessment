import ProductsService
import Testing
@testable import TechAssessment

struct AddProductViewModelTests {
    private let productsService: ProductsService
    private let sut: AddProductView.ViewModel
    
    init() {
        self.productsService = ProductsServiceImpl(
            localProductsServiceDependencies: .init(
                inMemoryStorage: true
            )
        )
        self.sut = AddProductView.ViewModel(productsService: self.productsService)
    }
    
    @Test
    func viewModelDefaultState() {
        #expect(sut.isSaveButtonDisabled)
        #expect(sut.productName.isEmpty)
        #expect(!sut.showErrorAlert)
    }
    
    @Test
    func viewModelStateWhenProductNameIsNotEmpty() {
        sut.productName = "Product"
        
        #expect(!sut.isSaveButtonDisabled)
        #expect(!sut.productName.isEmpty)
        #expect(!sut.showErrorAlert)
    }
    
    @Test
    func viewModelStateWhenProductIsSaved() async throws {
        sut.productName = "Product"
        
        #expect(!sut.isSaveButtonDisabled)
        #expect(!sut.productName.isEmpty)
        #expect(!sut.showErrorAlert)
        
        sut.saveProduct()
        
        /// Let the save task finish
        try await Task.sleep(for: .seconds(1))
        
        #expect(sut.isSaveButtonDisabled)
        #expect(sut.productName.isEmpty)
        #expect(!sut.showErrorAlert)
    }
}
