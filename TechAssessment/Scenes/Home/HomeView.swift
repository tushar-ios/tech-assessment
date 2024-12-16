import ProductsService
import SwiftUI

struct HomeView: View {
    @State private(set) var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            pickerView
            productsListView
                .navigationTitle("List")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    toolbarContent
                }
        }
    }
    
    private var pickerView: some View {
        Picker("Sort by", selection: $viewModel.sortOrder) {
            Text("Alpha")
                .tag(ProductsSortOrder.byName)
            Text("Creation Time")
                .tag(ProductsSortOrder.byDate)
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    private var productsListView: some View {
        ProductsListView(
            sortOrder: $viewModel.sortOrder,
            viewModel: .init(
                productsService: viewModel.productsService,
                sortOrder: viewModel.sortOrder
            )
        )
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(
                destination: AddProductView(
                    viewModel: .init(
                        productsService: viewModel.productsService
                    )
                )
            ) {
                Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    HomeView(
        viewModel: .init(
            productsService: ProductsServiceImpl(
                localProductsServiceDependencies: .init(
                    inMemoryStorage: true
                )
            )
        )
    )
}
