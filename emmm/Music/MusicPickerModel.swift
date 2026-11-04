import Combine

@MainActor
final class MusicPickerModel: ObservableObject {
    @Published private(set) var songs: [RecentSong] = []
    @Published private(set) var isLoading = false
    @Published private(set) var failureMessage: String?

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
        do {
            songs = try await music.fetchRecentSongs()
            failureMessage = nil
        } catch {
            print("最近聴いた曲の取得に失敗: \(error)")
            failureMessage = Self.failureMessage(for: error)
        }
    }

    private static func failureMessage(for error: Error) -> String {
        if let accessError = error as? MusicLibraryAccessError {
            return accessError.localizedDescription
        }
        return "Apple Musicから曲を取得できませんでした"
    }
}
