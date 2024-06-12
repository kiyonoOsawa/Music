import UIKit
import MusicKit
import StoreKit
import MediaPlayer

class MusicViewController: UIViewController {
    
    @IBOutlet weak var musicTable: UITableView!
    
    weak var viewModel = MusicKitViewModel.shared
    var musicSubscription: MusicSubscription?
    var musicTitles: [String] = []
    var musicImageURLs: [URL?] = []
    var musicArtists: [String] = []
    var musicIDs: [MusicItemID] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicTable.dataSource = self
        musicTable.delegate = self
        musicTable.register(UINib(nibName: "MusicListTableViewCell", bundle: nil), forCellReuseIdentifier: "musicListCell")
        design()
        fetchMusicData()
    }
    
    func design() {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "mainColor")
    }
    
    func fetchMusicData() {
        Task {
            do {
                let (titles, images, artists, ids) = try await viewModel?.getCurrentMusic() ?? ([], [], [], [])
                musicTitles.append(contentsOf: titles)
                musicImageURLs.append(contentsOf: images)
                musicArtists.append(contentsOf: artists)
                musicIDs.append(contentsOf: ids)
                musicTable.reloadData()
            } catch {
                print("Error fetching music data: \(error)")
            }
        }
        print("こっちの数は？\(musicTitles.count)")
        print("これもみたい\(MPMusicPlayerController.systemMusicPlayer.nowPlayingItem!)")
    }
    
}

extension MusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicListCell", for: indexPath) as! MusicListTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.musicTitle.text = musicTitles[indexPath.item]
        //取得してきた画像を表示
        if let url = musicImageURLs[indexPath.item] {
            loadImage(from: url) { image in
                DispatchQueue.main.async {
                    cell.musicImage.image = image
                }
            }
        } else {
            cell.musicImage.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let count = (self.navigationController?.viewControllers.count)! - 2
        let preVC = self.navigationController?.viewControllers[count] as? AddDiaryViewController
        preVC?.musicTitle = musicTitles[indexPath.row]
        preVC?.musicImageURL = musicImageURLs[indexPath.row]!
        preVC?.musicArtist = musicArtists[indexPath.row]
        preVC?.musicIDString = musicIDs[indexPath.row].rawValue
        self.navigationController?.popViewController(animated: true)
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
