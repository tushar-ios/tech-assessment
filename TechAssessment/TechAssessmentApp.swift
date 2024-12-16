import SwiftUI

@main
struct TechAssessmentApp: App {
    var body: some Scene {
        WindowGroup {
            let dependenciesProvider: AppDependenciesProvider = AppDependenciesContainer()
            HomeView(
                viewModel: .init(productsService: dependenciesProvider.productsService)
            )
        }
    }
}
