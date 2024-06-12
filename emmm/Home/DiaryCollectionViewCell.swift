import UIKit

class DiaryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var emotionImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var musicTitleLabel: UILabel!
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var musicArtistLabel: UILabel!
    @IBOutlet weak var contentAble: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        design()
    }
    
    func design() {
        musicImageView.layer.cornerRadius = 5
        musicImageView.layer.masksToBounds = true
    }
    
}
