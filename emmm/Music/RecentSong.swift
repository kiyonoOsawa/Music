import Foundation

struct RecentSong: Identifiable, Equatable {
    let id: String
    let title: String
    let artistName: String
    let artworkURL: URL?

    static let previewSamples: [RecentSong] = [
        RecentSong(id: "preview-1", title: "Good Day", artistName: "Sample Artist", artworkURL: nil),
        RecentSong(id: "preview-2", title: "Rainy Night", artistName: "Another Artist", artworkURL: nil),
        RecentSong(id: "preview-3", title: "A Very Long Song Title That Should Truncate", artistName: "Long Name Artist", artworkURL: nil)
    ]
}
