import Combine

@MainActor
final class MusicPickerModel: ObservableObject {
    @Published private(set) var songs: [RecentSong] = []
    @Published private(set) var isLoading = false

    private let music: MusicKitViewModel?

    init(music: MusicKitViewModel = .shared) {
        self.music = music
    }

    init(previewSongs: [RecentSong]) {
        songs = previewSongs
        music = nil
    }

    func load() async {
        guard let music, songs.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        songs = (try? await music.fetchRecentSongs()) ?? []
    }
}
