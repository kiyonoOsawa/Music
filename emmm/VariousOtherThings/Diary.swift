import Foundation
import SwiftData

@Model
final class Diary {
    @Attribute(.unique) var id: String
    var musicIDString: String
    var musicTitle: String
    var musicImageString: String?
    var artistName: String
    var date: Date
    var emotion: Int
    var content: String
    var listOrder: Int

    init(
        id: String = UUID().uuidString,
        musicIDString: String = "",
        musicTitle: String = "",
        musicImageString: String? = nil,
        artistName: String = "",
        date: Date = Date(),
        emotion: Int = 0,
        content: String = "",
        listOrder: Int = 0
    ) {
        self.id = id
        self.musicIDString = musicIDString
        self.musicTitle = musicTitle
        self.musicImageString = musicImageString
        self.artistName = artistName
        self.date = date
        self.emotion = emotion
        self.content = content
        self.listOrder = listOrder
    }

    var musicImage: URL? {
        guard let musicImageString else { return nil }
        return URL(string: musicImageString)
    }

    var cardItem: DiaryCardItem {
        DiaryCardItem(
            id: id,
            date: date,
            musicTitle: musicTitle,
            artistName: artistName,
            musicImageURL: musicImage,
            emotion: emotion,
            content: content,
            musicIDString: musicIDString
        )
    }
}
