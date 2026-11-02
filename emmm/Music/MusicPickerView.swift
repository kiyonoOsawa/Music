import SwiftUI

struct MusicPickerView: View {
    @ObservedObject var model: MusicPickerModel
    var onSelect: (RecentSong) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            if model.isLoading && model.songs.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if model.songs.isEmpty {
                Text("最近聴いた曲はありません")
                    .foregroundStyle(Color("blackColor"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(model.songs) { song in
                    Button {
                        onSelect(song)
                        dismiss()
                    } label: {
                        MusicPickerRow(song: song)
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.plain)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .tint(Color("mainColor"))
        .task {
            await model.load()
        }
    }
}

private struct MusicPickerRow: View {
    let song: RecentSong

    var body: some View {
        HStack(spacing: 12) {
            artwork
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .font(.body)
                    .foregroundStyle(Color("blackColor"))
                    .lineLimit(1)
                Text(song.artistName)
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private var artwork: some View {
        if let url = song.artworkURL {
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

#Preview {
    NavigationStack {
        MusicPickerView(model: MusicPickerModel(previewSongs: RecentSong.previewSamples), onSelect: { _ in })
    }
}
