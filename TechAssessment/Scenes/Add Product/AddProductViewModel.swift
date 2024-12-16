import Observation
import ProductsService

extension AddProductView {
    @Observable
    final class ViewModel {
        private let productsService: ProductsService
        private var isSaveInProgress: Bool = false
        var productName: String = ""
        var showErrorAlert: Bool = false
        
        /// Trims the whitespaces and new lines from the product name
        private var trimmedProductName: String {
            productName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        /// Returns true if a save is already in progress or if the product name is empty
        var isSaveButtonDisabled: Bool {
            isSaveInProgress || trimmedProductName.isEmpty
        }
        
        init(productsService: ProductsService) {
            self.productsService = productsService
        }
        
        /// Saves product concurrently and not on main thread
        func saveProduct() {
            isSaveInProgress = true
            Task {
                let shouldShowErrorAlert: Bool
                do {
                    let product = Product(name: trimmedProductName)
                    try await productsService.createAndSaveProductLocally(product)
                    shouldShowErrorAlert = false
                } catch {
                    shouldShowErrorAlert = true
                }
                
                await MainActor.run {
                    showErrorAlert = shouldShowErrorAlert
                    isSaveInProgress = false
                    productName = ""
                }
            }
        }
    }
}
