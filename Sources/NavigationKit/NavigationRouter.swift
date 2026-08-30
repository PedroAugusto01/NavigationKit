import UIKit

/// `Router` implementation backed by a real `UINavigationController`.
public final class NavigationRouter: NSObject, Router {
    public let navigationController: UINavigationController

    public init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    public func push(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let completion else {
            navigationController.pushViewController(viewController, animated: animated)
            return
        }

        // `pushViewController` has no completion parameter; `CATransaction` is the standard
        // way to observe when its (possibly animated) transition actually finishes.
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    public func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        navigationController.present(viewController, animated: animated, completion: completion)
    }

    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }

    public func popViewController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    public func popToRootViewController(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
    }

    public func setRoot(_ viewController: UIViewController, animated: Bool) {
        navigationController.setViewControllers([viewController], animated: animated)
    }
}
