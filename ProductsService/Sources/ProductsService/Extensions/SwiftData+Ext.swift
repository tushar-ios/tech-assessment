import SwiftData

extension ModelContainer {
    /// Creates a model container based on what kind is needed - in memory or not
    /// - Parameter inMemory: sets `isStoredInMemoryOnly`
    /// - Returns: An initialized model container
    private static func modelContainer(inMemory: Bool) -> ModelContainer {
        do {
            let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
            let container = try ModelContainer(for: ProductModel.self, configurations: modelConfiguration)
            return container
        } catch let error {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    /// Model container which is `not` in memory
    static var persistedModelContainer: ModelContainer {
        modelContainer(inMemory: false)
    }
    
#if DEBUG
    /// Model container which is in memory - typically for previews or testing
    static var inMemoryModelContainer: ModelContainer {
        modelContainer(inMemory: true)
    }
#endif
}
