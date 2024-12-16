import ProductsService
import SwiftUI

struct ProductsListView: View {
    @Binding private(set) var sortOrder: ProductsSortOrder
    @State private(set) var viewModel: ViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                productView(product)
                    .onAppear {
                        viewModel.fetchNextProductsAfter(product)
                    }
            }
        }
        .overlay {
            if viewModel.products.isEmpty {
                noProductsView
            }
        }
        .onChange(of: sortOrder, initial: false) { _, newSortOrder in
            viewModel.sortOrder = newSortOrder
            viewModel.fetchProducts(.refresh)
        }
        .onFirstAppear {
            viewModel.subscribeToLocalProductsChangePublisher()
            viewModel.fetchProducts(.initial)
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("Okay") {
                viewModel.showErrorAlert = false
            }
        } message: {
            Text("An error occurred while fetching the products.")
        }
    }
    
    private func productView(_ product: Product) -> some View {
        HStack {
            Text(product.name)
            Spacer()
            Text(product.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                .font(.footnote)
                .foregroundStyle(.gray)
        }
    }
    
    private var noProductsView: some View {
        Text("No products found")
            .font(.title)
            .foregroundColor(.gray)
    }
}

#Preview {
    @Previewable @State var sortOrder: ProductsSortOrder = .byName
    return ProductsListView(
        sortOrder: $sortOrder,
        viewModel: .init(
            productsService: ProductsServiceImpl(
                localProductsServiceDependencies: .init(
                    inMemoryStorage: true
                )
            ),
            sortOrder: sortOrder
        )
    )
}
