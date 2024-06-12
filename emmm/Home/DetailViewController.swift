import UIKit
import RealmSwift
import MusicKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backGround: UIView!
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var musicTitleLabel: UILabel!
    @IBOutlet weak var emotionImage: UIImageView!
    @IBOutlet weak var emotionName: UILabel!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var playButton: UIButton!
    
    weak var viewModel = MusicKitViewModel.shared
    var diary: Results<Diary>!
    
    var date = String()
    //    var musicIDString = String()
    var emotionNum = Int()
    var content = String()
    var musicID: MusicItemID = ""
    var tappedBtn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
        setData()
        fetchMusicDetails()
    }
    
    func design() {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "mainColor")
        musicImageView.layer.masksToBounds = true
        musicImageView.layer.cornerRadius = 12
        backGround.layer.cornerRadius = 15
        backGround.layer.opacity = 0.4
        emotionName.layer.masksToBounds = true
        emotionName.layer.cornerRadius = 6
        emotionName.layer.borderWidth = 1.0
        emotionName.layer.borderColor = UIColor(named: "mainColor")?.cgColor
        contentText.isEditable = false
        var configuration = UIButton.Configuration.plain()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .default)
        let systemImage = UIImage(systemName: "play", withConfiguration: symbolConfiguration)
        configuration.image = systemImage
        playButton.configuration = configuration
        playButton.tintColor = .white
        playButton.backgroundColor = UIColor(named: "mainColor")
        playButton.layer.cornerRadius = 40
    }
    
    func setData() {
        dateLabel.text = date
        setEmotion()
        musicTitleLabel.adjustsFontSizeToFitWidth = true
        contentText.text = content
    }
    
    func setEmotion() {
        emotionImage.image = UIImage(named: viewModel!.emotionNames[emotionNum])
        emotionName.text = viewModel?.emotionNames[emotionNum]
    }
    
    private func fetchMusicDetails() {
        Task {
            do {
                let song = try await viewModel?.getSpecificSongsOnCatalog(ID: musicID)
                if let song = song {
                    musicTitleLabel.text = song.title
                    if let artworkURL = song.artwork?.url(width: 500, height: 500) {
                        loadImage(from: artworkURL) { image in
                            DispatchQueue.main.async {
                                self.musicImageView.image = image
                            }
                        }
                    }
                }
            } catch {
                print("Failed to fetch music details: \(error)")
            }
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    func setDismissKeyboard() {
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func playButtonTapped() {
        self.tappedBtn.toggle()
        if tappedBtn == false {
            viewModel?.stopSystemMusic(ID: musicID)
            playButton.setImage(UIImage(systemName: "play"), for: .normal)
        } else if tappedBtn == true {
            viewModel?.startSystemMusic(ID: musicID)
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
        }
    }
}
