import SwiftUI

struct HomeView: View {
    @ObservedObject var model: HomeModel
    var onSelect: (DiaryCardItem) -> Void
    @State private var isShowingAddDiary = false

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
        .safeAreaInset(edge: .bottom, spacing: 0) {
            AddDiaryButton {
                isShowingAddDiary = true
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color("lightColor"))
        }
        .sheet(isPresented: $isShowingAddDiary) {
            AddDiaryView()
        }
    }
}

private struct AddDiaryButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color("mainColor"))
                .frame(width: 80, height: 80)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color("mainColor").opacity(0.5), radius: 5)
        }
        .buttonStyle(.plain)
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
