import Foundation
import MusicKit

struct EmotionPlaylist: Identifiable, Equatable {
    let id: String
    let title: String
    let artwork: Artwork?
    let url: URL?

    static let previewSamples: [EmotionPlaylist] = [
        EmotionPlaylist(id: "preview-happy", title: "happy", artwork: nil, url: URL(string: "https://music.apple.com")!),
        EmotionPlaylist(id: "preview-sad", title: "sad", artwork: nil, url: URL(string: "https://music.apple.com")!),
        EmotionPlaylist(id: "preview-love", title: "love", artwork: nil, url: URL(string: "https://music.apple.com")!),
        EmotionPlaylist(id: "preview-joy", title: "joy", artwork: nil, url: URL(string: "https://music.apple.com")!)
    ]
}
