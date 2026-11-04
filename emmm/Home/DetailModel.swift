import Combine
import Foundation
import MusicKit

@MainActor
final class DetailModel: ObservableObject {
    let item: DiaryCardItem
    @Published private(set) var title: String
    @Published private(set) var artworkURL: URL?
    @Published private(set) var isPlaying = false

    private let music: MusicKitViewModel?

    init(item: DiaryCardItem, music: MusicKitViewModel = .shared) {
        self.item = item
        title = item.musicTitle
        artworkURL = item.musicImageURL
        self.music = music
    }

    init(previewItem: DiaryCardItem) {
        item = previewItem
        title = previewItem.musicTitle
        artworkURL = previewItem.musicImageURL
        music = nil
    }

    func load() async {
        guard let music else { return }
        let id = MusicItemID(rawValue: item.musicIDString)
        guard let song = try? await music.getSpecificSongsOnCatalog(ID: id) else { return }
        title = song.title
        if let url = song.artwork?.url(width: 500, height: 500) {
            artworkURL = url
        }
    }

    func togglePlayback() {
        guard let music else {
            isPlaying.toggle()
            return
        }
        if isPlaying {
            isPlaying = false
            music.stopSystemMusic()
            return
        }
        guard !item.musicIDString.isEmpty else { return }
        Task {
            do {
                try await music.startSystemMusic(ID: MusicItemID(rawValue: item.musicIDString))
                isPlaying = true
            } catch {
                print("再生に失敗: \(error)")
                isPlaying = false
            }
        }
    }
}
