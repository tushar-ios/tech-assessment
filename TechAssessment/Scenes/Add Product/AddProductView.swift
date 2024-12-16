import ProductsService
import SwiftUI

struct AddProductView: View {
    @State private(set) var viewModel: ViewModel
    
    var body: some View {
        formView
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
            .alert("Error", isPresented: $viewModel.showErrorAlert) {
                Button("Okay") {
                    viewModel.showErrorAlert = false
                }
            } message: {
                Text("An error occurred while saving the product.")
            }
    }
    
    private var formView: some View {
        Form {
            Text("Garment Name:")
                .listRowSeparator(.hidden)
            TextField("e.g., Shirt, Coat", text: $viewModel.productName)
                .padding()
                .overlay (
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                )
        }
        .listRowSeparator(.hidden)
        .scrollContentBackground(.hidden)
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                viewModel.saveProduct()
            }
            .disabled(viewModel.isSaveButtonDisabled)
        }
    }
}

#Preview {
    AddProductView(
        viewModel: .init(
            productsService: ProductsServiceImpl(
                localProductsServiceDependencies: .init(
                    inMemoryStorage: true
                )
            )
        )
    )
}
