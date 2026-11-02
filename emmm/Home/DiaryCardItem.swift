import Foundation

struct DiaryCardItem: Identifiable, Equatable {
    let id: String
    let date: Date
    let musicTitle: String
    let artistName: String
    let musicImageURL: URL?
    let emotion: Int
    let content: String
    let musicIDString: String

    static let emotionNames = ["happy", "regret", "anxiety", "angry", "sad", "love", "joy", "tired"]

    var emotionName: String {
        guard Self.emotionNames.indices.contains(emotion) else { return Self.emotionNames[0] }
        return Self.emotionNames[emotion]
    }

    static let previewSamples: [DiaryCardItem] = [
        DiaryCardItem(
            id: "preview-happy",
            date: Date(),
            musicTitle: "Good Day",
            artistName: "Sample Artist",
            musicImageURL: nil,
            emotion: 0,
            content: "朝に聴いた曲",
            musicIDString: "preview-happy"
        ),
        DiaryCardItem(
            id: "preview-sad",
            date: Date().addingTimeInterval(-60 * 60 * 24),
            musicTitle: "Rainy Night",
            artistName: "Another Artist",
            musicImageURL: nil,
            emotion: 4,
            content: "",
            musicIDString: "preview-sad"
        ),
        DiaryCardItem(
            id: "preview-love",
            date: Date().addingTimeInterval(-60 * 60 * 24 * 6),
            musicTitle: "A Very Long Song Title That Should Truncate",
            artistName: "Long Name Artist",
            musicImageURL: nil,
            emotion: 5,
            content: "本文あり",
            musicIDString: "preview-love"
        )
    ]
}
