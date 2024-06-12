import Foundation
import RealmSwift

class Diary: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var musicIDString: String = ""
    @objc dynamic var musicTitle = String()
    @objc dynamic var musicImageString: String? = nil
    @objc dynamic var artistName: String = ""
    @objc dynamic var date = Date()
    @objc dynamic var emotion = Int()
    @objc dynamic var content = String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // URL型のカスタムプロパティ
    var musicImage: URL? {
        get {
            if let urlString = musicImageString {
                return URL(string: urlString)
            }
            return nil
        }
        set {
            musicImageString = newValue?.absoluteString
        }
    }
}
