import XCTest
import UIKit
import NavigationKit
@testable import NavigationKitMock

final class MockRouterTests: XCTestCase {
    func testPushRecordsTheViewControllerAndCallsCompletion() {
        let router = MockRouter()
        let viewController = UIViewController()
        var didCallCompletion = false

        router.push(viewController, animated: true) { didCallCompletion = true }

        XCTAssertEqual(router.pushedViewControllers, [viewController])
        XCTAssertTrue(didCallCompletion)
    }

    func testPresentRecordsTheViewController() {
        let router = MockRouter()
        let viewController = UIViewController()

        router.present(viewController, animated: true, completion: nil)

        XCTAssertEqual(router.presentedViewControllers, [viewController])
    }

    func testSetRootRecordsTheRoot() {
        let router = MockRouter()
        let viewController = UIViewController()

        router.setRoot(viewController, animated: false)

        XCTAssertEqual(router.rootViewController, viewController)
    }

    func testPopAndPopToRootAndDismissAreRecorded() {
        let router = MockRouter()

        router.popViewController(animated: true)
        router.popToRootViewController(animated: true)
        router.dismiss(animated: true, completion: nil)

        XCTAssertEqual(router.poppedCount, 1)
        XCTAssertTrue(router.didPopToRoot)
        XCTAssertTrue(router.didDismiss)
    }
}
