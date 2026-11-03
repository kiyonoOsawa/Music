import UIKit
import MusicKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.registerForRemoteNotifications()
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
}

