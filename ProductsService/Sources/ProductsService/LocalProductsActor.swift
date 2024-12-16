import SwiftData

/// Actor to handle expensive data operations outside main thread
@ModelActor
actor LocalProductsActor {
    func productsTotalCount() async throws -> Int {
        try modelContext.fetchCount(FetchDescriptor<ProductModel>())
    }
    
    func fetchProducts(_ fetchDescriptor: FetchDescriptor<ProductModel>) async throws -> [Product] {
        try modelContext
            .fetch(fetchDescriptor)
            .map { $0.mapToProduct() }
    }
    
    func createAndSaveProduct(_ product: ProductModel) async throws {
        modelContext.insert(product)
        try modelContext.save()
    }
}
