import Combine
import Foundation
import MusicKit
import SwiftData

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

    func save(in context: ModelContext) {
        guard savesToStore else { return }
        let nextOrder = ((try? context.fetch(FetchDescriptor<Diary>())) ?? []).map(\.listOrder).max().map { $0 + 1 } ?? 0
        let diary = Diary(
            musicIDString: song?.id ?? "",
            musicTitle: song?.title ?? "",
            musicImageString: song?.artworkURL?.absoluteString,
            artistName: song?.artistName ?? "",
            date: date,
            emotion: emotion,
            content: content,
            listOrder: nextOrder
        )
        context.insert(diary)

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
