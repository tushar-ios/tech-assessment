import Foundation

/// Sort order by which the products should be sorted
public enum ProductsSortOrder {
    case byDate, byName
}

extension ProductsSortOrder {
    func mapToProductModelSortDescriptor() -> SortDescriptor<ProductModel> {
        switch self {
        case .byDate: SortDescriptor(\ProductModel.createdAt)
        case .byName: SortDescriptor(\ProductModel.name)
        }
    }
}
