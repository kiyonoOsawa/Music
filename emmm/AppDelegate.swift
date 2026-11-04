import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.registerForRemoteNotifications()
        Task {
            do {
                try await MusicKitViewModel.shared.ensureEmotionPlaylists()
            } catch {
                print("感情プレイリストの作成に失敗: \(error)")
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

