import UIKit
import MusicKit
import RealmSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var diaryCollectionView: UICollectionView!
    
    static let shared = HomeViewController()
    let emotionNames = ["happy", "regret", "anxiety", "angry", "sad", "love", "joy", "tired"]
    
    let realm = try! Realm()
    var diary: Results<Diary>!
    var musicImageURL: URL? = URL(string: "https://example.com")!
    var diaryCell = DiaryCollectionViewCell()
    var emotionNum = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryCollectionView.delegate = self
        diaryCollectionView.dataSource = self
        self.diary = realm.objects(Diary.self)
        diaryCollectionView.reloadData()
        setUI()
        print("とってきたい！\(diary)")
        do{
            let realm = try Realm()
            diary = realm.objects(Diary.self)
            diaryCollectionView.reloadData()
        } catch {
        }
        NotificationCenter.default.addObserver(self, selector: #selector(diarySaved(_:)), name: Notification.Name("DiarySaved"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.diary = realm.objects(Diary.self)
        diaryCollectionView.reloadData()
    }
    
    @objc func diarySaved(_ notification: Notification) {
        // データを再読み込み
        self.diary = realm.objects(Diary.self)
        diaryCollectionView.reloadData()
    }
    
    deinit {
        // NotificationCenterのObserverを削除
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUI() {
        diaryCollectionView.register(UINib(nibName: "DiaryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiaryCell")
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as! DiaryCollectionViewCell
        cell.layer.cornerRadius = 16
        cell.layer.shadowColor = UIColor(named: "accentColor")?.cgColor
        cell.layer.shadowOpacity = 0.50
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 12
        cell.layer.masksToBounds = false
        cell.musicTitleLabel.adjustsFontSizeToFitWidth = true
        cell.musicArtistLabel.adjustsFontSizeToFitWidth = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        cell.dateLabel.text = dateFormatter.string(from: diary[indexPath.row].date)
        cell.musicTitleLabel.text = diary[indexPath.row].musicTitle
        cell.musicArtistLabel.text = diary[indexPath.row].artistName
        musicImageURL = URL(string: diary[indexPath.row].musicImageString!)
        if let url = musicImageURL {
            loadImage(from: url) { image in
                DispatchQueue.main.async {
                    cell.musicImageView.image = image
                }
            }
        }
        emotionNum = diary[indexPath.row].emotion
        cell.emotionImage.image = UIImage(named: emotionNames[emotionNum])
        
        if diary[indexPath.row].content == "" {
            cell.contentAble.isHidden = true
        } else {
            cell.contentAble.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        if let nextVC = storyboard.instantiateViewController(withIdentifier: "ditailVC") as? DetailViewController {
            nextVC.modalTransitionStyle = .coverVertical
            nextVC.modalPresentationStyle = .pageSheet
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            nextVC.date = dateFormatter.string(from: diary[indexPath.row].date)
            let musicID = MusicItemID(rawValue: diary[indexPath.row].musicIDString)
            nextVC.musicID = musicID
            nextVC.emotionNum = diary[indexPath.row].emotion
            nextVC.content = diary[indexPath.row].content
            nextVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            print("ダメでした")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = diary[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Delete", attributes: .destructive) { _ in
                let realm = try! Realm()
                if let objectToDelete = realm.object(ofType: Diary.self, forPrimaryKey: item.id) {
                    try! realm.write {
                        realm.delete(objectToDelete)
                    }
                }
                self.diaryCollectionView.reloadData()
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = .zero
        let space: CGFloat = 32
        let cellWidth: CGFloat = diaryCollectionView.frame.width - space
        let cellHeight: CGFloat = 122
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = .zero
        return UIEdgeInsets(top: 16, left:16, bottom: 16, right: 16)
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
