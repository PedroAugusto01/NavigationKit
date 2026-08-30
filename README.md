# NavigationKit

A small coordinator-pattern navigation library for UIKit. No third-party dependencies.

Licensed under [MIT](LICENSE).

It ships three library targets:

- **NavigationKitCore** — the `Coordinator` protocol and `BaseCoordinator`. Pure Swift, no `UIKit` import anywhere, so it builds and tests on macOS with no simulator.
- **NavigationKit** — `Router` (a protocol wrapping navigation) and `NavigationRouter`, its `UINavigationController`-backed implementation.
- **NavigationKitMock** — `MockRouter`, a test double for unit-testing coordinators without presenting real view controllers.

## Installation

```swift
.package(url: "https://github.com/PedroAugusto01/NavigationKit", from: "1.0.0")
```

```swift
.product(name: "NavigationKitCore", package: "NavigationKit"),
.product(name: "NavigationKit", package: "NavigationKit"),
.product(name: "NavigationKitMock", package: "NavigationKit"), // test targets only
```

Requires iOS 13+ (`NavigationKitCore` alone also builds for macOS 10.15+, since it has no UIKit dependency).

## How it works

A coordinator owns one part of the navigation flow — which screens to show, in what order —
so that logic doesn't end up scattered across view controllers:

```swift
final class ProfileCoordinator: BaseCoordinator {
    private let router: Router
    private let userID: String

    init(router: Router, userID: String) {
        self.router = router
        self.userID = userID
    }

    override func start() {
        let viewController = ProfileViewController(userID: userID)
        viewController.onEditTapped = { [weak self] in self?.showEdit() }
        router.push(viewController)
    }

    private func showEdit() {
        router.push(EditProfileViewController())
    }
}
```

`Router` is what a coordinator actually talks to — it never touches `UINavigationController`
directly:

```swift
let navigationController = UINavigationController()
let router = NavigationRouter(navigationController: navigationController)
let coordinator = ProfileCoordinator(router: router, userID: "42")

coordinator.start()
window.rootViewController = navigationController
```

### Child coordinators

`startChild` runs a child coordinator and automatically removes it from `children` once it
calls `finish()` — the common "run a sub-flow, then drop it" pattern:

```swift
final class HomeCoordinator: BaseCoordinator {
    private let router: Router

    init(router: Router) { self.router = router }

    override func start() {
        let viewController = HomeViewController()
        viewController.onStartOnboarding = { [weak self] in self?.showOnboarding() }
        router.setRoot(viewController, animated: false)
    }

    private func showOnboarding() {
        let onboarding = OnboardingCoordinator(router: router)
        startChild(onboarding)
    }
}

final class OnboardingCoordinator: BaseCoordinator {
    private let router: Router
    init(router: Router) { self.router = router }

    override func start() {
        let viewController = OnboardingViewController()
        viewController.onFinished = { [weak self] in self?.finish() } // triggers onFinish
        router.push(viewController)
    }
}
```

### Testing a coordinator

```swift
import NavigationKit
import NavigationKitMock

func testStartPushesTheProfileScreen() {
    let router = MockRouter()
    let coordinator = ProfileCoordinator(router: router, userID: "42")

    coordinator.start()

    XCTAssertTrue(router.pushedViewControllers.first is ProfileViewController)
}
```

`NavigationKitCoreTests` covers `Coordinator`'s child-management logic with no `UIKit`
dependency at all (`swift test` on macOS); `NavigationKitTests` covers `NavigationRouter`
against a real `UINavigationController` and needs an iOS/iOS Simulator destination.

## Demo

`DemoApp/` is an [XcodeGen](https://github.com/yonaskolb/XcodeGen) project — a plain
code-only UIKit app (no storyboard) with an `AppCoordinator` that pushes from a home screen to
a detail screen through a `NavigationRouter`.

```bash
brew install xcodegen   # if you don't have it
cd DemoApp
xcodegen generate
open NavigationKitDemo.xcodeproj
```

## Tests

```bash
swift test
```

(`NavigationKitTests` and `NavigationKitMockTests` link `UIKit`, so run them against an iOS
Simulator destination — e.g. `xcodebuild test -scheme NavigationKit-Package -destination
'platform=iOS Simulator,name=iPhone 16'` — `swift test` alone only covers `NavigationKitCoreTests`
on macOS.)
