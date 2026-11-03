import Combine
import UIKit

@MainActor
final class PlaylistModel: ObservableObject {
    @Published private(set) var playlists: [EmotionPlaylist] = []
    @Published private(set) var isLoading = false

    private let music: MusicKitViewModel?

    init(music: MusicKitViewModel = .shared) {
        self.music = music
    }

    init(previewPlaylists: [EmotionPlaylist]) {
        playlists = previewPlaylists
        music = nil
    }

    func load() async {
        guard let music else { return }
        isLoading = true
        defer { isLoading = false }
        playlists = (try? await music.fetchEmotionPlaylists()) ?? []
    }

    func open(_ playlist: EmotionPlaylist) {
        UIApplication.shared.open(playlist.url)
    }
}
