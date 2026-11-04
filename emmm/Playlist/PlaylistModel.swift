import Combine
import UIKit

@MainActor
final class PlaylistModel: ObservableObject {
    @Published private(set) var playlists: [EmotionPlaylist] = []
    @Published private(set) var isLoading = false
    @Published private(set) var failureMessage: String?

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
        do {
            playlists = try await music.fetchEmotionPlaylists()
            failureMessage = nil
        } catch {
            print("プレイリストの取得に失敗: \(error)")
            failureMessage = Self.failureMessage(for: error)
        }
    }

    func open(_ playlist: EmotionPlaylist) {
        if let url = playlist.url {
            UIApplication.shared.open(url)
            return
        }
        guard let music else { return }
        Task {
            do {
                try await music.playPlaylist(id: playlist.id)
                failureMessage = nil
                if let musicApp = URL(string: "music://") {
                    await UIApplication.shared.open(musicApp)
                }
            } catch {
                print("プレイリストの再生に失敗: \(error)")
                failureMessage = Self.failureMessage(for: error)
            }
        }
    }

    private static func failureMessage(for error: Error) -> String {
        if let accessError = error as? MusicLibraryAccessError {
            return accessError.localizedDescription
        }
        return "Apple Musicからプレイリストを取得できませんでした"
    }
}
