import SwiftUI

struct DiaryCard: View {
    let diary: DiaryCardItem

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 16) {
                Image(diary.emotionName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                if !diary.content.isEmpty {
                    Image(systemName: "text.alignleft")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.primary)
                        .frame(width: 26, height: 29)
                } else {
                    Color.clear.frame(width: 26, height: 29)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(DiaryCardDate.string(from: diary.date))
                    .font(.system(size: 32))
                    .foregroundStyle(Color("blackColor"))
                Text(diary.musicTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color("blackColor"))
                    .lineLimit(1)
                Text(diary.artistName)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.gray)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            artwork
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 122)
        .background(Color.white.opacity(0.45))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color("accentColor").opacity(0.5), radius: 12)
    }

    @ViewBuilder
    private var artwork: some View {
        if let url = diary.musicImageURL {
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

private enum DiaryCardDate {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()

    static func string(from date: Date) -> String {
        formatter.string(from: date)
    }
}

#Preview {
    DiaryCard(diary: DiaryCardItem.previewSamples[0])
        .padding()
        .background(Color("lightColor"))
}
