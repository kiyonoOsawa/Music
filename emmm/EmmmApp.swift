import SwiftData
import SwiftUI

@main
struct EmmmApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    private let container: ModelContainer

    init() {
        let container = try! ModelContainer(for: Diary.self)
        DiaryStoreImporter.importIfNeeded(into: container.mainContext)
        self.container = container
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(container)
    }
}
