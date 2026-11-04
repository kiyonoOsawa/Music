import Foundation
import MusicKit

enum MusicLibraryAccessError: LocalizedError {
    case notAuthorized
    case songNotFound
    case playlistNotFound

    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Apple Musicの利用を許可してください"
        case .songNotFound:
            return "曲を見つけられませんでした"
        case .playlistNotFound:
            return "プレイリストを見つけられませんでした"
        }
    }
}

@MainActor
final class MusicKitViewModel {
    static let shared = MusicKitViewModel()

    private let playlistDescription = "A library of songs shared by the app."
    private let transientArtworkPrefix = "musicKit://artwork/transient"
    private var emotionPlaylistsTask: Task<Void, Error>?

    func requireAuthorization() async throws {
        let status: MusicAuthorization.Status
        if MusicAuthorization.currentStatus == .notDetermined {
            status = await MusicAuthorization.request()
        } else {
            status = MusicAuthorization.currentStatus
        }
        guard status == .authorized else {
            throw MusicLibraryAccessError.notAuthorized
        }
    }

    /// 起動時とプレイリスト画面から同時に呼ばれても、作成処理は一度だけ走らせる。
    func ensureEmotionPlaylists() async throws {
        if let emotionPlaylistsTask {
            return try await emotionPlaylistsTask.value
        }
        let task = Task { try await createMissingEmotionPlaylists() }
        emotionPlaylistsTask = task
        do {
            try await task.value
        } catch {
            emotionPlaylistsTask = nil
            throw error
        }
    }

    func fetchRecentSongs() async throws -> [RecentSong] {
        try await requireAuthorization()
        var request = MusicRecentlyPlayedRequest<Song>()
        request.limit = 30
        return try await request.response().items.map { song in
            RecentSong(
                id: song.id.rawValue,
                title: song.title,
                artistName: song.artistName,
                artworkURL: displayArtworkURL(song.artwork, size: 200)
            )
        }
    }

    func getSpecificSongsOnCatalog(ID: MusicItemID) async throws -> Song {
        try await requireAuthorization()
        guard !ID.rawValue.isEmpty else { throw MusicLibraryAccessError.songNotFound }
        let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: ID)
        guard let song = try await request.response().items.first else {
            throw MusicLibraryAccessError.songNotFound
        }
        return song
    }

    func startSystemMusic(ID: MusicItemID) async throws {
        let song = try await getSpecificSongsOnCatalog(ID: ID)
        SystemMusicPlayer.shared.queue = [song]
        try await SystemMusicPlayer.shared.play()
    }

    func stopSystemMusic() {
        SystemMusicPlayer.shared.stop()
    }

    /// 同じ名前のプレイリストが重複していても、感情ごとに一つだけ感情の順で返す。
    func fetchEmotionPlaylists() async throws -> [EmotionPlaylist] {
        try await requireAuthorization()
        do {
            try await ensureEmotionPlaylists()
        } catch {
            print("感情プレイリストの作成に失敗: \(error)")
        }
        let playlists = try await libraryPlaylists()
        return DiaryCardItem.emotionNames.compactMap { name in
            guard let playlist = playlist(named: name, in: playlists) else { return nil }
            return EmotionPlaylist(
                id: playlist.id.rawValue,
                title: playlist.name,
                artworkURL: displayArtworkURL(playlist.artwork, size: 200),
                url: playlist.url
            )
        }
    }

    func playPlaylist(id: String) async throws {
        try await requireAuthorization()
        var request = MusicLibraryRequest<Playlist>()
        request.filter(matching: \.id, equalTo: MusicItemID(id))
        guard let playlist = try await request.response().items.first else {
            throw MusicLibraryAccessError.playlistNotFound
        }
        SystemMusicPlayer.shared.queue = [playlist]
        try await SystemMusicPlayer.shared.play()
    }

    func addSongToEmotionPlaylist(emotion: String, ID: MusicItemID) async throws {
        let song = try await getSpecificSongsOnCatalog(ID: ID)
        let playlists = try await libraryPlaylists()
        if let playlist = playlist(named: emotion, in: playlists) {
            try await MusicLibrary.shared.add(song, to: playlist)
            return
        }
        _ = try await MusicLibrary.shared.createPlaylist(
            name: emotion,
            description: playlistDescription,
            authorDisplayName: nil,
            items: [song]
        )
    }

    private func createMissingEmotionPlaylists() async throws {
        try await requireAuthorization()
        let playlists = try await libraryPlaylists()
        for name in DiaryCardItem.emotionNames where playlist(named: name, in: playlists) == nil {
            _ = try await MusicLibrary.shared.createPlaylist(
                name: name,
                description: playlistDescription,
                authorDisplayName: nil
            )
        }
    }

    private func libraryPlaylists() async throws -> MusicItemCollection<Playlist> {
        try await MusicLibraryRequest<Playlist>().response().items
    }

    private func playlist(named name: String, in playlists: MusicItemCollection<Playlist>) -> Playlist? {
        playlists.first { $0.name.lowercased() == name.lowercased() }
    }

    private func displayArtworkURL(_ artwork: Artwork?, size: Int) -> URL? {
        guard let url = artwork?.url(width: size, height: size) else { return nil }
        if url.absoluteString.hasPrefix(transientArtworkPrefix) { return nil }
        return url
    }
}
