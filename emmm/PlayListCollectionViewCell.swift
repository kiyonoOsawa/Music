import UIKit

class PlayListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var playListTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        design()
    }
    
    func design() {
        musicImage.layer.cornerRadius = 12
    }
}
