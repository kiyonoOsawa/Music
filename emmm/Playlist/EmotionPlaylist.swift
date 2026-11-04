import Foundation

struct EmotionPlaylist: Identifiable, Equatable {
    let id: String
    let title: String
    let artworkURL: URL?
    let url: URL?

    static let previewSamples: [EmotionPlaylist] = [
        EmotionPlaylist(id: "preview-happy", title: "happy", artworkURL: nil, url: URL(string: "https://music.apple.com")!),
        EmotionPlaylist(id: "preview-sad", title: "sad", artworkURL: nil, url: URL(string: "https://music.apple.com")!),
        EmotionPlaylist(id: "preview-love", title: "love", artworkURL: nil, url: URL(string: "https://music.apple.com")!),
        EmotionPlaylist(id: "preview-joy", title: "joy", artworkURL: nil, url: URL(string: "https://music.apple.com")!)
    ]
}
