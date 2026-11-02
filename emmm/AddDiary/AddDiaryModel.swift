import Combine
import Foundation
import MusicKit
import RealmSwift

@MainActor
final class AddDiaryModel: ObservableObject {
    @Published var date = Date()
    @Published var song: RecentSong?
    @Published var emotion = 0
    @Published var content = ""

    private let savesToStore: Bool

    init() {
        savesToStore = true
    }

    init(previewSong: RecentSong?, content: String) {
        song = previewSong
        self.content = content
        savesToStore = false
    }

    func save() {
        guard savesToStore else { return }
        let diary = Diary()
        diary.date = date
        diary.musicTitle = song?.title ?? ""
        diary.artistName = song?.artistName ?? ""
        diary.musicImage = song?.artworkURL
        diary.musicIDString = song?.id ?? ""
        diary.emotion = emotion
        diary.content = content

        let realm = try! Realm()
        try? realm.write {
            realm.add(diary)
        }

        guard let song else { return }
        let emotionName = DiaryCardItem.emotionNames[emotion]
        let musicID = song.id
        Task {
            try? await MusicKitViewModel.shared.addMusicToLikedMusicLibrary(
                emotion: emotionName,
                ID: MusicItemID(rawValue: musicID)
            )
        }
    }
}
