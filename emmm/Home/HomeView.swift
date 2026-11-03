import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Diary.listOrder) private var storedDiaries: [Diary]
    @State private var previewDiaries: [DiaryCardItem]?
    @State private var isShowingAddDiary = false

    init() {
        _previewDiaries = State(initialValue: nil)
        _storedDiaries = Query(sort: \Diary.listOrder)
    }

    init(previewDiaries: [DiaryCardItem]) {
        _previewDiaries = State(initialValue: previewDiaries)
        _storedDiaries = Query(sort: \Diary.listOrder)
    }

    private var diaries: [DiaryCardItem] {
        previewDiaries ?? storedDiaries.map(\.cardItem)
    }

    var body: some View {
        ScrollView {
            if diaries.isEmpty {
                Text("日記はまだありません")
                    .font(.body)
                    .foregroundStyle(Color("blackColor"))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(diaries) { diary in
                        NavigationLink {
                            DetailView(model: DetailModel(item: diary))
                        } label: {
                            DiaryCard(diary: diary)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                delete(id: diary.id)
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
        .background(Color("lightColor"))
        .navigationTitle("Music")
        .navigationBarTitleDisplayMode(.inline)
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

    private func delete(id: String) {
        if previewDiaries != nil {
            previewDiaries?.removeAll { $0.id == id }
            return
        }
        guard let diary = storedDiaries.first(where: { $0.id == id }) else { return }
        modelContext.delete(diary)
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
    var diaries: [DiaryCardItem]

    var body: some View {
        NavigationStack {
            HomeView(previewDiaries: diaries)
        }
        .modelContainer(for: Diary.self, inMemory: true)
    }
}
