import SwiftUI
import UIKit

class HomeViewController: UIViewController {

    private let model = HomeModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let host = UIHostingController(rootView: HomeView(model: model) { [weak self] item in
            self?.openDetail(item)
        })
        host.view.backgroundColor = .clear
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        host.didMove(toParent: self)
    }

    private func openDetail(_ item: DiaryCardItem) {
        let host = UIHostingController(rootView: DetailView(model: DetailModel(item: item)))
        host.hidesBottomBarWhenPushed = true
        navigationController?.navigationBar.tintColor = UIColor(named: "mainColor")
        navigationController?.pushViewController(host, animated: true)
    }
}
