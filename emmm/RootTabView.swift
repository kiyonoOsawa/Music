import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack {
                PlaylistView()
            }
            .tint(Color("blackColor"))
            .tabItem {
                Label("PlayList", systemImage: "play.square.stack")
            }
        }
        .tint(Color("accentColor"))
    }
}

#Preview {
    RootTabView()
        .modelContainer(for: Diary.self, inMemory: true)
}
