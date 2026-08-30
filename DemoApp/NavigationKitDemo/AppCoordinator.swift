import NavigationKit
import NavigationKitCore

final class AppCoordinator: BaseCoordinator {
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    override func start() {
        showHome()
    }

    private func showHome() {
        let homeViewController = HomeViewController()
        homeViewController.onShowDetail = { [weak self] text in
            self?.showDetail(text: text)
        }
        router.setRoot(homeViewController, animated: false)
    }

    private func showDetail(text: String) {
        router.push(DetailViewController(text: text), animated: true)
    }
}
