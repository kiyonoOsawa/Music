import Foundation
import RealmSwift
import SwiftData

/// Realm に保存されていた日記を、同じ値のまま一度だけ SwiftData へ写す。
enum DiaryStoreImporter {
    private static let didImportKey = "didImportRealmDiariesToSwiftData"

    static func importIfNeeded(into context: ModelContext) {
        guard !UserDefaults.standard.bool(forKey: didImportKey) else { return }
        do {
            let config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: nil,
                deleteRealmIfMigrationNeeded: false,
                objectTypes: [LegacyDiary.self]
            )
            let realm = try Realm(configuration: config)
            let existing = try context.fetch(FetchDescriptor<Diary>())
            var knownIDs = Set(existing.map(\.id))
            var nextOrder = (existing.map(\.listOrder).max() ?? -1) + 1

            for old in realm.objects(LegacyDiary.self) {
                guard !knownIDs.contains(old.id) else { continue }
                context.insert(
                    Diary(
                        id: old.id,
                        musicIDString: old.musicIDString,
                        musicTitle: old.musicTitle,
                        musicImageString: old.musicImageString,
                        artistName: old.artistName,
                        date: old.date,
                        emotion: old.emotion,
                        content: old.content,
                        listOrder: nextOrder
                    )
                )
                knownIDs.insert(old.id)
                nextOrder += 1
            }

            if context.hasChanges {
                try context.save()
            }
            UserDefaults.standard.set(true, forKey: didImportKey)
        } catch {
            // 失敗したときは印を付けない。Realm のファイルは残し、次回起動でやり直す。
            print("Diary import failed: \(error)")
        }
    }
}

/// 既存の Realm ファイル上のクラス名は "Diary"。
@objc(Diary)
final class LegacyDiary: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var musicIDString: String = ""
    @objc dynamic var musicTitle = ""
    @objc dynamic var musicImageString: String? = nil
    @objc dynamic var artistName: String = ""
    @objc dynamic var date = Date()
    @objc dynamic var emotion = 0
    @objc dynamic var content = ""

    override static func primaryKey() -> String? {
        "id"
    }
}
