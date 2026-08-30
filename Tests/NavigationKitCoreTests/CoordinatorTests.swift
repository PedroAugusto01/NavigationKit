import XCTest
@testable import NavigationKitCore

private final class SpyCoordinator: Coordinator {
    var children: [Coordinator] = []
    var onFinish: (() -> Void)?
    private(set) var didStart = false

    func start() {
        didStart = true
    }
}

final class CoordinatorTests: XCTestCase {
    func testAddChildAppendsToChildren() {
        let parent = SpyCoordinator()
        let child = SpyCoordinator()

        parent.addChild(child)

        XCTAssertTrue(parent.children.first === child)
    }

    func testRemoveChildDropsItByIdentity() {
        let parent = SpyCoordinator()
        let child = SpyCoordinator()
        parent.addChild(child)

        parent.removeChild(child)

        XCTAssertTrue(parent.children.isEmpty)
    }

    func testStartChildStartsItAndRegistersItAsAChild() {
        let parent = SpyCoordinator()
        let child = SpyCoordinator()

        parent.startChild(child)

        XCTAssertTrue(child.didStart)
        XCTAssertTrue(parent.children.first === child)
    }

    func testStartChildRemovesItWhenItFinishes() {
        let parent = SpyCoordinator()
        let child = SpyCoordinator()
        parent.startChild(child)

        child.onFinish?()

        XCTAssertTrue(parent.children.isEmpty)
    }

    func testFinishCallsOnFinish() {
        let coordinator = SpyCoordinator()
        var didFinish = false
        coordinator.onFinish = { didFinish = true }

        coordinator.finish()

        XCTAssertTrue(didFinish)
    }
}
