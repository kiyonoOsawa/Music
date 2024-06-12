import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.init(name: "HelveticaNeue-Bold", size: 13), .foregroundColor: UIColor(named: "accentColor")], for: .selected)
        UITabBarItem.appearance().selectedImage?.withTintColor(.red)
        setupMiddleButton()
    }
    
    // TabBarButton – 中央ボタンの設定
    func setupMiddleButton() {
        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-40, y: -52, width: 80, height: 80))
        // ボタンを自分好みのスタイルに設定する
        //システムアイコン名、サイズを設定
        var configuration = UIButton.Configuration.plain()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .default)
        let systemImage = UIImage(systemName: "plus", withConfiguration: symbolConfiguration)
        configuration.image = systemImage
        middleBtn.configuration = configuration
        middleBtn.tintColor = UIColor(named: "mainColor")
        middleBtn.backgroundColor = UIColor.white
        middleBtn.layer.cornerRadius = 40
        middleBtn.layer.shadowColor = UIColor(named: "mainColor")?.cgColor
        middleBtn.layer.shadowOpacity = 0.50
        middleBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        middleBtn.layer.shadowRadius = 5
        // タブバーに追加し、クリック イベントを追加する
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    // メニュー ボタンのタッチ アクション
    @objc func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 2 // 中央のタブを選択します。タブが 3 つしかない場合は "1" を使用します。
        let storyboard: UIStoryboard = UIStoryboard(name: "AddDiary", bundle: nil)
        let addVC = storyboard.instantiateViewController(withIdentifier: "addNC")
        self.present(addVC, animated: true, completion: nil)
    }
}
