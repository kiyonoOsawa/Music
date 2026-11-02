import SwiftUI

struct HomeView: View {
    @ObservedObject var model: HomeModel
    var onSelect: (DiaryCardItem) -> Void

    var body: some View {
        ScrollView {
            if model.diaries.isEmpty {
                Text("日記はまだありません")
                    .font(.body)
                    .foregroundStyle(Color("blackColor"))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(model.diaries) { diary in
                        Button {
                            onSelect(diary)
                        } label: {
                            DiaryCard(diary: diary)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                model.delete(id: diary.id)
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
        .background(Color("lightColor"))
    }
}

#Preview("日記あり") {
    HomePreview(diaries: DiaryCardItem.previewSamples)
}

#Preview("空") {
    HomePreview(diaries: [])
}

private struct HomePreview: View {
    @StateObject private var model: HomeModel

    init(diaries: [DiaryCardItem]) {
        _model = StateObject(wrappedValue: HomeModel(previewDiaries: diaries))
    }

    var body: some View {
        NavigationStack {
            HomeView(model: model, onSelect: { _ in })
                .navigationTitle("Music")
        }
    }
}
