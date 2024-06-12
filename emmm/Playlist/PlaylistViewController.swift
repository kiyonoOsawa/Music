import UIKit
import RealmSwift
import MusicKit
import MediaPlayer
import StoreKit

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var playListCollectionView: UICollectionView!
    
    weak var viewModel = MusicKitViewModel.shared
    var emotionNames = ["happy", "regret", "anxiety", "angry", "sad", "love", "joy", "tired"]
    var playListTitles: [String] = []
    var playListImageURLs: [URL?] = []
    var playListIDs: [URL?] = []
    var filteredImageURLs: [URL?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playListCollectionView.delegate = self
        playListCollectionView.dataSource = self
        playListCollectionView.register(UINib(nibName: "PlayListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlayListCell")
        design()
        fetchPlayListData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playListCollectionView.reloadData()
    }
    
    func design() {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "blackColor")
    }
    
    func fetchPlayListData() {
        Task {
            do {
                let (titles, ids, images) = try await viewModel?.fetchMusicPlaylist() ?? ([], [], [])
                
                // 絞り込み処理
                let transientPrefix = "musicKit://artwork/transient"
                var filteredTitles: [String] = []
                var filteredIDs: [URL?] = []
                var filteredImages: [URL?] = []
                
                for (index, title) in titles.enumerated() {
                    let imageURL = images[index]
                    // emotionNamesと一致し、かつURLがtransientPrefixで始まらない場合のみ追加
                    if emotionNames.contains(title.lowercased()) && !(imageURL?.absoluteString.hasPrefix(transientPrefix) ?? false) {
                        filteredTitles.append(title)
                        filteredIDs.append(ids[index])
                        filteredImages.append(imageURL)
                    }
                }
                
                // 絞り込んだプレイリストを使用
                playListTitles = filteredTitles
                playListIDs = filteredIDs
                playListImageURLs = filteredImages
                
                playListCollectionView.reloadData()
            } catch {
                print("Error fetching music data: \(error)")
            }
        }
    }
    
    func openAppleMusicPlaylist(withID id: URL) {
        if let url = URL(string: "\(id)") {
            UIApplication.shared.open(url)
        }
    }
}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playListTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayListCell", for: indexPath) as! PlayListCollectionViewCell
        cell.backgroundColor = .clear
        // Tag番号を使ってインスタンスをつくる
        let photoImageView = cell.contentView.viewWithTag(1)  as! UIImageView
        print("ここの中身見れたら最高\(playListImageURLs)")
        let url = playListImageURLs[indexPath.item]
        if let url = url, filteredImageURLs.contains(url) {
            cell.isHidden = true
        } else {
            cell.isHidden = false
            if let url = url {
                loadImage(from: url) { image in
                    DispatchQueue.main.async {
                        photoImageView.image = image
                    }
                }
            }
        }
        let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
        titleLabel.text = playListTitles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPlaylistID = playListIDs[indexPath.item]!
        openAppleMusicPlaylist(withID: selectedPlaylistID)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = .zero
        let space: CGFloat = 8
        let cellWidth: CGFloat = UIScreen.main.bounds.width / 2 - space * 4
        let cellHeight: CGFloat = 206
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = .zero
        return UIEdgeInsets(top: 16, left:16, bottom: 8, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
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
}
