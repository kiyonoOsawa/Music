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
    }
}
