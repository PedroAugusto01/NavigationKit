import UIKit
import NavigationKit

/// Test double for ``Router``. Records every call instead of driving real view controllers, so
/// coordinators can be unit-tested without presenting anything.
///
/// ```swift
/// let router = MockRouter()
/// let coordinator = ProfileCoordinator(router: router)
///
/// coordinator.start()
///
/// XCTAssertTrue(router.pushedViewControllers.first is ProfileViewController)
/// ```
public final class MockRouter: NSObject, Router {
    public private(set) var pushedViewControllers: [UIViewController] = []
    public private(set) var presentedViewControllers: [UIViewController] = []
    public private(set) var poppedCount = 0
    public private(set) var didPopToRoot = false
    public private(set) var didDismiss = false
    public private(set) var rootViewController: UIViewController?

    public override init() {}

    public func push(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        pushedViewControllers.append(viewController)
        completion?()
    }

    public func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentedViewControllers.append(viewController)
        completion?()
    }

    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        didDismiss = true
        completion?()
    }

    public func popViewController(animated: Bool) {
        poppedCount += 1
    }

    public func popToRootViewController(animated: Bool) {
        didPopToRoot = true
    }

    public func setRoot(_ viewController: UIViewController, animated: Bool) {
        rootViewController = viewController
    }
}
