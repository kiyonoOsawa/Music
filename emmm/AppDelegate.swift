import UIKit
import MusicKit
import RealmSwift
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.registerForRemoteNotifications()
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: nil,
            deleteRealmIfMigrationNeeded: true
        )
        Realm.Configuration.defaultConfiguration = config
        Task {
            await MusicAuthorization.request()
            let emotionNames = ["happy", "regret", "anxiety", "angry", "sad", "love", "joy", "tired"]
            
            emotionNames.map { item in
                Task {
                    let requestPlaylists = MusicLibraryRequest<Playlist>()
                    let responsePlaylists = try await requestPlaylists.response()
                    let playlists = responsePlaylists.items
                    print("🐶",requestPlaylists, responsePlaylists.items)
                    if !playlists.contains(where: { $0.name == "happy" }) {
                        try await MusicKitViewModel.createMusicPlaylist(name: item)
                    } else if !playlists.contains(where: { $0.name == "regret" }) {
                        try await MusicKitViewModel.createMusicPlaylist(name: item)
                    } else if !playlists.contains(where: { $0.name == "anxiety" }) {
                        try await MusicKitViewModel.createMusicPlaylist(name: item)
                    } else if !playlists.contains(where: { $0.name == "angry" }) {
                        try await MusicKitViewModel.createMusicPlaylist(name: item)
                    } else if !playlists.contains(where: { $0.name == "sad" }) {
                        try await MusicKitViewModel.createMusicPlaylist(name: item)
                    } else if !playlists.contains(where: { $0.name == "love" }) {
                        try await MusicKitViewModel.createMusicPlaylist(name: item)
                    } else if !playlists.contains(where: { $0.name == "joy" }) {
                        try await MusicKitViewModel.createMusicPlaylist(name: item)
                    } else if !playlists.contains(where: { $0.name == "tired" }) {
                        try await MusicKitViewModel.createMusicPlaylist(name: item)
                    }
                }
            }
        }
//        registerForPushNotifications()  
        return true
    }
    
//    func registerForPushNotifications() {
//        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
//            (granted, error) in
//            print("Permission granted: \(granted)")
//            // 1. Check if permission granted
//            guard granted else { return }
//            // 2. Attempt registration for remote notifications on the main thread
//            DispatchQueue.main.async {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
//    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

