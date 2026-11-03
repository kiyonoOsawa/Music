import SwiftUI

struct PlaylistView: View {
    @StateObject private var model: PlaylistModel

    init() {
        _model = StateObject(wrappedValue: PlaylistModel())
    }

    init(previewPlaylists: [EmotionPlaylist]) {
        _model = StateObject(wrappedValue: PlaylistModel(previewPlaylists: previewPlaylists))
    }

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            if model.isLoading && model.playlists.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)
            } else if model.playlists.isEmpty {
                Text("プレイリストはまだありません")
                    .foregroundStyle(Color("blackColor"))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)
            } else {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(model.playlists) { playlist in
                        Button {
                            model.open(playlist)
                        } label: {
                            PlaylistCard(playlist: playlist)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            }
        }
        .background(Color("lightColor"))
        .navigationTitle("PlayList")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await model.load()
        }
    }
}

private struct PlaylistCard: View {
    let playlist: EmotionPlaylist

    var body: some View {
        VStack(spacing: 8) {
            artwork
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text(playlist.title)
                .font(.body)
                .foregroundStyle(Color("blackColor"))
                .lineLimit(1)
        }
        .frame(height: 206, alignment: .top)
    }

    @ViewBuilder
    private var artwork: some View {
        if let url = playlist.artworkURL {
            AsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Image("emmm_stroke").resizable().scaledToFit()
            }
        } else {
            Image("emmm_stroke").resizable().scaledToFit()
        }
    }
}

#Preview("プレイリストあり") {
    NavigationStack {
        PlaylistView(previewPlaylists: EmotionPlaylist.previewSamples)
    }
}

#Preview("空") {
    NavigationStack {
        PlaylistView(previewPlaylists: [])
    }
}
