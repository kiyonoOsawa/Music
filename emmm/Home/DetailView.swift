import SwiftUI

struct DetailView: View {
    @ObservedObject var model: DetailModel

    var body: some View {
        VStack(spacing: 16) {
            Image("emmm_bar")
                .resizable()
                .scaledToFill()
                .frame(height: 4)
                .frame(maxWidth: .infinity)
                .clipped()

            HStack(spacing: 16) {
                Image(model.item.emotionName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text(DetailDate.string(from: model.item.date))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color("blackColor"))
            }

            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("lightColor").opacity(0.4))
                    .frame(width: 250, height: 250)
                artwork
                    .frame(width: 226, height: 226)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            HStack(spacing: 12) {
                Text(model.title)
                    .font(.system(size: 23, weight: .semibold))
                    .foregroundStyle(Color("blackColor"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Text(model.item.emotionName)
                    .font(.system(size: 16))
                    .foregroundStyle(Color("mainColor"))
                    .padding(.horizontal, 8)
                    .frame(height: 32)
                    .overlay {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color("mainColor"), lineWidth: 1)
                    }
            }

            Text(model.item.content)
                .font(.system(size: 14))
                .foregroundStyle(Color("blackColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)

            Spacer(minLength: 0)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                model.togglePlayback()
            } label: {
                Image(systemName: model.isPlaying ? "pause.fill" : "play")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 80, height: 80)
                    .background(Color("mainColor"))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .padding(.bottom, 8)
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .tint(Color("mainColor"))
        .task {
            await model.load()
        }
    }

    @ViewBuilder
    private var artwork: some View {
        if let url = model.artworkURL {
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

private enum DetailDate {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    static func string(from date: Date) -> String {
        formatter.string(from: date)
    }
}

#Preview {
    DetailPreview(item: DiaryCardItem.previewSamples[0])
}

private struct DetailPreview: View {
    @StateObject private var model: DetailModel

    init(item: DiaryCardItem) {
        _model = StateObject(wrappedValue: DetailModel(previewItem: item))
    }

    var body: some View {
        NavigationStack {
            DetailView(model: model)
        }
    }
}
