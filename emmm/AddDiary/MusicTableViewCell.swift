import UIKit
import MusicKit
import StoreKit
import MediaPlayer

class MusicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var musicViewModel = MusicKitViewModel()
    var musicSubscription: MusicSubscription?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        musicImage.layer.cornerRadius = 12
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

