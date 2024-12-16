import SwiftUI

/// A `ViewModifier` that executes a given action once when the view appears.
struct RunOnceViewModifier: ViewModifier {
    @State private var hasAppeared = false
    private let action: () -> ()
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                action()
            }
    }
}

extension View {
    func onFirstAppear(_ action: @escaping () -> ()) -> some View {
        modifier(RunOnceViewModifier(action: action))
    }
}
