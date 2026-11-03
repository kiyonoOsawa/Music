import Foundation
import MusicKit
import MediaPlayer
import StoreKit

@MainActor
class MusicKitViewModel: NSObject {
    
    @Published var musicRequest = MusicRecentlyPlayedRequest<Song>()
    @Published var response: MusicRecentlyPlayedResponse<Song>!
    @Published var musicID: String?
    
    static let shared = MusicKitViewModel()
    let emotionNames = ["happy", "regret", "anxiety", "angry", "sad", "love", "joy", "tired"]
    
    //最近聴いた曲を最新から順に取得する
    func getCurrentMusic() async throws -> ([String], [URL?], [String], [MusicItemID]) {
        //limitで取得個数制限
        musicRequest.limit = 30
        response = try await musicRequest.response()
        let titles = response.items.compactMap { $0.title }
        let images = response.items.compactMap { $0.artwork?.url(width: 200, height: 200) }
        let artists = response.items.compactMap { $0.artistName }
        let ids = response.items.compactMap{ $0.id }
        print("最近聴いた曲のタイトル: \(titles)")
        print("何を取得できているのかみたい\(response)")
        print("何型？\(type(of: ids))")
        return (titles, images, artists, ids)
    }

    func fetchRecentSongs() async throws -> [RecentSong] {
        musicRequest.limit = 30
        response = try await musicRequest.response()
        return response.items.map { song in
            RecentSong(
                id: song.id.rawValue,
                title: song.title,
                artistName: song.artistName,
                artworkURL: song.artwork?.url(width: 200, height: 200)
            )
        }
    }
    
    func fetchMusicID() async {
        do {
            // MusicKit APIを使用して音楽IDを取得
            let request = MusicCatalogSearchRequest(term: "Your Search Term", types: [Song.self])
            let response = try await request.response()
            
            if let song = response.songs.first {
                DispatchQueue.main.async {
                    self.musicID = song.id.rawValue
                }
            }
        } catch {
            print("Error fetching music ID: \(error)")
        }
    }
    
    func getSpecificSongsOnCatalog(ID: MusicItemID) async throws ->  MusicItemCollection<Song>.Element {
        //試しに上の関数で取ってきた30個目の曲の情報を持ってくる
        //idは曲一つ一つに必ず振られてるからidだけ抑えとけばこれで検索できる
        let Songrequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: ID)
        let Songresponse = try await Songrequest.response()
        //        let song = Songresponse.items.first
        guard !Songresponse.items.isEmpty, let song = Songresponse.items.first else {
            throw NSError(domain: "MusicKitViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Song not found"])
        }
        print("id検索結果",song)
        return song
    }
    
    func startSystemMusic(ID: MusicItemID) {
        Task {
            do {
                let song = try await getSpecificSongsOnCatalog(ID: ID)
                SystemMusicPlayer.shared.queue = [song]
                try await SystemMusicPlayer.shared.play()
            } catch {
                print("システムで再生する時のエラー",error.localizedDescription)
            }
        }
    }
    
    func stopSystemMusic(ID: MusicItemID) {
        Task {
            do {
                try await SystemMusicPlayer.shared.stop()
            } catch {
                print("システムで再生する時のエラー",error.localizedDescription)
            }
        }
    }
    
    func fetchMusicPlaylist() async throws -> ([String], [URL?], [URL?]) {
        let requestPlaylists = MusicLibraryRequest<Playlist>()
        let responsePlaylists = try await requestPlaylists.response()
        let playlists = responsePlaylists.items
        let playlistTitles = playlists.map { $0.name }
        let playlistIDs = playlists.map { $0.url }
        let playlistImages = playlists.map { $0.artwork?.url(width: 200, height: 200) }
        print("わんわん🐶",requestPlaylists, responsePlaylists.debugDescription)
        return (playlistTitles, playlistIDs, playlistImages)
    }

    func fetchEmotionPlaylists() async throws -> [EmotionPlaylist] {
        let response = try await MusicLibraryRequest<Playlist>().response()
        let transientPrefix = "musicKit://artwork/transient"
        return response.items.compactMap { playlist in
            guard DiaryCardItem.emotionNames.contains(playlist.name.lowercased()) else { return nil }
            let artworkURL = playlist.artwork?.url(width: 200, height: 200)
            if artworkURL?.absoluteString.hasPrefix(transientPrefix) == true { return nil }
            guard let url = playlist.url else { return nil }
            return EmotionPlaylist(id: url.absoluteString, title: playlist.name, artworkURL: artworkURL, url: url)
        }
    }
    
    static func createMusicPlaylist(name: String) async throws {
        Task {
            do{
                try await MusicLibrary.shared.createPlaylist(name: name, description: "A library of songs shared by the app.", authorDisplayName: nil)
            }catch{
                print("😺",error)
            }
        }
    }
    
    func addMusicToLikedMusicLibrary(emotion: String, ID: MusicItemID) async throws {
        Task {
            do {
                let Request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: ID)
                let Response = try await Request.response()
                var requestPlaylists = MusicLibraryRequest<Playlist>()
                //プレイリストとfilterのtextの名前一致してないと動かないから気をつけて
                requestPlaylists.filter(text: emotion)
                let responsePlaylists = try await requestPlaylists.response()
                try await MusicLibrary.shared.add(Response.items.first!, to: responsePlaylists.items.first!)
            } catch (let error) {
                print(error)
            }
        }
    }
}
