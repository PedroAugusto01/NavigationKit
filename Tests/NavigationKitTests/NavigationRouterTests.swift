import XCTest
import UIKit
@testable import NavigationKit

final class NavigationRouterTests: XCTestCase {
    func testSetRootReplacesTheStack() {
        let navigationController = UINavigationController()
        let router = NavigationRouter(navigationController: navigationController)
        let viewController = UIViewController()

        router.setRoot(viewController, animated: false)

        XCTAssertEqual(navigationController.viewControllers, [viewController])
    }

    func testPushAddsToTheStack() {
        let navigationController = UINavigationController(rootViewController: UIViewController())
        let router = NavigationRouter(navigationController: navigationController)
        let pushed = UIViewController()

        router.push(pushed, animated: false)

        XCTAssertEqual(navigationController.viewControllers.last, pushed)
    }

    func testPopRemovesTheTopViewController() {
        let root = UIViewController()
        let navigationController = UINavigationController(rootViewController: root)
        let router = NavigationRouter(navigationController: navigationController)
        navigationController.pushViewController(UIViewController(), animated: false)

        router.popViewController(animated: false)

        XCTAssertEqual(navigationController.viewControllers, [root])
    }

    func testPopToRootLeavesOnlyTheFirstViewController() {
        let root = UIViewController()
        let navigationController = UINavigationController(rootViewController: root)
        let router = NavigationRouter(navigationController: navigationController)
        navigationController.pushViewController(UIViewController(), animated: false)
        navigationController.pushViewController(UIViewController(), animated: false)

        router.popToRootViewController(animated: false)

        XCTAssertEqual(navigationController.viewControllers, [root])
    }
}
