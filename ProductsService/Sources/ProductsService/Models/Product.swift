import Foundation

/// Data transfer object of a product
public struct Product: Identifiable, Sendable, Equatable {
    public let id: UUID
    public var createdAt: Date
    public var name: String
    
    public init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        name: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
    }
}

extension Product {
    func mapToProductModel() -> ProductModel {
        ProductModel(createdAt: createdAt, name: name)
    }
}
