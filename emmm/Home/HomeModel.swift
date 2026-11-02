import Combine
import RealmSwift

@MainActor
final class HomeModel: ObservableObject {
    @Published private(set) var diaries: [DiaryCardItem]

    private let realm: Realm?
    private var token: NotificationToken?

    init() {
        let realm = try! Realm()
        let results = realm.objects(Diary.self)
        self.realm = realm
        diaries = results.map(Self.item)
        token = results.observe { [weak self] change in
            let items: [DiaryCardItem]
            switch change {
            case .initial(let results), .update(let results, _, _, _):
                items = results.map(Self.item)
            case .error:
                return
            }
            Task { @MainActor in
                self?.diaries = items
            }
        }
    }

    init(previewDiaries: [DiaryCardItem]) {
        realm = nil
        diaries = previewDiaries
    }

    func delete(id: String) {
        guard let realm else {
            diaries.removeAll { $0.id == id }
            return
        }
        guard let object = realm.object(ofType: Diary.self, forPrimaryKey: id) else { return }
        try? realm.write {
            realm.delete(object)
        }
    }

    private static func item(_ diary: Diary) -> DiaryCardItem {
        DiaryCardItem(
            id: diary.id,
            date: diary.date,
            musicTitle: diary.musicTitle,
            artistName: diary.artistName,
            musicImageURL: diary.musicImage,
            emotion: diary.emotion,
            content: diary.content,
            musicIDString: diary.musicIDString
        )
    }
}
