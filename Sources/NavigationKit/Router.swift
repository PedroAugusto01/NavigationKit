import UIKit

/// Wraps navigation behind a small, mockable protocol so coordinators depend on `Router`, not
/// on `UINavigationController` directly — that's what makes it possible to unit-test a
/// coordinator with `NavigationKitMock.MockRouter` instead of driving real view controllers.
public protocol Router: AnyObject {
    func push(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func popViewController(animated: Bool)
    func popToRootViewController(animated: Bool)
    func setRoot(_ viewController: UIViewController, animated: Bool)
}

public extension Router {
    func push(_ viewController: UIViewController, animated: Bool = true) {
        push(viewController, animated: animated, completion: nil)
    }

    func present(_ viewController: UIViewController, animated: Bool = true) {
        present(viewController, animated: animated, completion: nil)
    }

    func dismiss(animated: Bool = true) {
        dismiss(animated: animated, completion: nil)
    }
}
