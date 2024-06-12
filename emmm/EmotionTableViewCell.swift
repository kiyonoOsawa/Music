import UIKit

class EmotionTableViewCell: UITableViewCell {
    
    @IBOutlet var emotionButtons: [UIButton]!
    @IBOutlet var emotionLabels: [UILabel]!
    
    weak var delegate: EmotionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        design()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func design() {
        for button in emotionButtons {
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(tappedBtn), for: .touchUpInside)
        }
    }
    
    @IBAction func tappedBtn(_ sender: UIButton) {
        emotionButtons.forEach { $0.alpha = ($0 == sender) ? 1.0 : 0.4 }
        emotionLabels.forEach {$0.alpha = ($0.tag == sender.tag) ? 1.0 : 0.4 }
        let tag = sender.tag
        delegate?.tappedBtn(cell: self, didTapButtonWithTag: tag)
    }
}

protocol EmotionTableViewCellDelegate: AnyObject {
    func tappedBtn(cell: EmotionTableViewCell, didTapButtonWithTag tag: Int)
}
