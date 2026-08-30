import UIKit

final class HomeViewController: UIViewController {
    var onShowDetail: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NavigationKit"
        view.backgroundColor = .systemBackground

        let button = UIButton(type: .system)
        button.setTitle("Show detail", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func didTapButton() {
        onShowDetail?("Pushed via NavigationRouter, by an AppCoordinator")
    }
}
