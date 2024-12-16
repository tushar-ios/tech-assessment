import Foundation
import SwiftData

/// The actual local storage product model
@Model
final class ProductModel {
    var createdAt: Date
    var name: String
    
    init(createdAt: Date, name: String) {
        self.createdAt = createdAt
        self.name = name
    }
}

extension ProductModel {
    func mapToProduct() -> Product {
        Product(createdAt: createdAt, name: name)
    }
}
