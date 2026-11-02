import MusicKit
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
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: "ditailVC") as? DetailViewController else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        nextVC.date = dateFormatter.string(from: item.date)
        nextVC.musicID = MusicItemID(rawValue: item.musicIDString)
        nextVC.emotionNum = item.emotion
        nextVC.content = item.content
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
