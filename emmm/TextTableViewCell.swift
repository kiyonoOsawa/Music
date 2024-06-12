import UIKit

class TextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var diaryTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        diaryTextField.placeholder = "テキストを入力"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
