import SwiftUI

struct AddDiaryView: View {
    @StateObject private var model: AddDiaryModel
    @StateObject private var musicPicker: MusicPickerModel
    @Environment(\.dismiss) private var dismiss

    init() {
        _model = StateObject(wrappedValue: AddDiaryModel())
        _musicPicker = StateObject(wrappedValue: MusicPickerModel())
    }

    init(previewModel: AddDiaryModel, previewPicker: MusicPickerModel) {
        _model = StateObject(wrappedValue: previewModel)
        _musicPicker = StateObject(wrappedValue: previewPicker)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    DiaryFormSection {
                        DatePicker("日付", selection: $model.date, displayedComponents: .date)
                            .foregroundStyle(Color("blackColor"))
                    }

                    DiaryFormSection {
                        NavigationLink {
                            MusicPickerView(model: musicPicker) { song in
                                model.song = song
                            }
                        } label: {
                            MusicSelectionRow(song: model.song)
                        }
                        .buttonStyle(.plain)
                    }

                    DiaryFormSection {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 16) {
                            ForEach(Array(DiaryCardItem.emotionNames.enumerated()), id: \.offset) { index, name in
                                Button {
                                    model.emotion = index
                                } label: {
                                    VStack(spacing: 6) {
                                        Image(name)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 44, height: 44)
                                        Text(name)
                                            .font(.caption)
                                            .foregroundStyle(Color("blackColor"))
                                            .lineLimit(1)
                                    }
                                    .opacity(model.emotion == index ? 1 : 0.4)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    DiaryFormSection {
                        TextField("テキストを入力", text: $model.content, axis: .vertical)
                            .lineLimit(6...12)
                            .foregroundStyle(Color("blackColor"))
                    }
                }
                .padding(16)
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color("mainColor"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        model.save()
                        dismiss()
                    }
                    .foregroundStyle(Color("accentColor"))
                }
            }
        }
    }
}

private struct DiaryFormSection<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("mainColor"), lineWidth: 1)
            }
    }
}

private struct MusicSelectionRow: View {
    let song: RecentSong?

    var body: some View {
        HStack(spacing: 16) {
            artwork
                .frame(width: 96, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            Text(song?.title ?? "音楽を選択")
                .font(song == nil ? .system(size: 16) : .body)
                .foregroundStyle(Color("blackColor"))
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }

    @ViewBuilder
    private var artwork: some View {
        if let url = song?.artworkURL {
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

#Preview("入力あり") {
    AddDiaryView(
        previewModel: AddDiaryModel(previewSong: RecentSong.previewSamples[0], content: "朝に聴いた曲"),
        previewPicker: MusicPickerModel(previewSongs: RecentSong.previewSamples)
    )
}

#Preview("未選択") {
    AddDiaryView(
        previewModel: AddDiaryModel(previewSong: nil, content: ""),
        previewPicker: MusicPickerModel(previewSongs: RecentSong.previewSamples)
    )
}
