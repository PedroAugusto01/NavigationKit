/// A coordinator owns one part of a navigation flow: it decides which screens to show and in
/// what order, keeping that logic out of view controllers/views.
///
/// This protocol is transport-agnostic — it doesn't know about `UIKit` or `UINavigationController`
/// at all, so it's unit-testable without a simulator. Pair it with `NavigationKit`'s `Router`
/// to actually push/present screens.
public protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    /// Called once this coordinator's flow is done, so its parent can react (drop the
    /// reference, dismiss a modal, move to the next flow).
    var onFinish: (() -> Void)? { get set }

    func start()
}

public extension Coordinator {
    func addChild(_ coordinator: Coordinator) {
        children.append(coordinator)
    }

    /// Removes `coordinator` from `children` by identity, so it (and everything it holds) can
    /// be deallocated.
    func removeChild(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }

    /// Starts `coordinator` as a child and removes it automatically once it finishes — the
    /// common "run a child flow, then drop it" pattern.
    func startChild(_ coordinator: Coordinator) {
        addChild(coordinator)
        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let coordinator else { return }
            self?.removeChild(coordinator)
        }
        coordinator.start()
    }

    func finish() {
        onFinish?()
    }
}
