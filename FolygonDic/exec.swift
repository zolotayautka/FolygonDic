import Foundation
import SQLite3
import AVFoundation
import UserNotifications

let fileManager = FileManager.default
let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
let define_study = documentsURL?.appendingPathComponent(".define")
var dbPath: String? = documentsURL?.appendingPathComponent("Dictionary").path

func make_db() {
    let cPath = dbPath!.cString(using: .utf8);
    let sql = """
        CREATE TABLE IF NOT EXISTS dic (
            kotoba CHAR(20) PRIMARY KEY,
            hinsi INT,
            imi CHAR(80),
            bikou CHAR(50),
            kanji CHAR(20),
            count INT DEFAULT 0
        );
        CREATE TABLE IF NOT EXISTS flag (
            lang TEXT,
            kazu INT
        );
        """
    var db: OpaquePointer? = nil
    sqlite3_open(cPath, &db)
    var errMsg: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(db, sql, nil, nil, &errMsg) != SQLITE_OK {}
        sqlite3_close(db)
}

struct ktb: Codable, Hashable, Identifiable {
    var id: String { kotoba }
    var kotoba: String
    var imi: String
    var bikou: String
    var kanji: String
    var hinsi: Int8
    var count: Int8 = 0
}

func sagasu(kotoba: String) -> [ktb] {
    let cPath = dbPath!.cString(using: .utf8);
    let queries = [
            "SELECT kotoba, imi, bikou, kanji, hinsi FROM dic WHERE kotoba LIKE ?;",
            "SELECT kotoba, imi, bikou, kanji, hinsi FROM dic WHERE imi LIKE ?;",
            "SELECT kotoba, imi, bikou, kanji, hinsi FROM dic WHERE kanji LIKE ?;",
            "SELECT kotoba, imi, bikou, kanji, hinsi FROM dic WHERE bikou LIKE ?;"
        ]
    var resultSet = Set<ktb>()
    var db: OpaquePointer? = nil
    sqlite3_open(cPath, &db)
    for sql in queries {
        var stmt: OpaquePointer? = nil
        sqlite3_prepare_v2(db, sql, -1, &stmt, nil)
        let pattern = "%\(kotoba)%"
        sqlite3_bind_text(stmt, 1, (pattern as NSString).utf8String, -1, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let kotobaStr = String(cString: sqlite3_column_text(stmt, 0))
            let imiStr    = String(cString: sqlite3_column_text(stmt, 1))
            let bikouStr  = String(cString: sqlite3_column_text(stmt, 2))
            let kanjiStr  = String(cString: sqlite3_column_text(stmt, 3))
            let hinsiInt  = Int8(sqlite3_column_int(stmt, 4))
            let word = ktb(kotoba: kotobaStr, imi: imiStr, bikou: bikouStr, kanji: kanjiStr, hinsi: hinsiInt)
            resultSet.insert(word)
        }
    }
    var tmp: [ktb] = Array(resultSet)
    tmp.sort { $0.kotoba < $1.kotoba }
    return tmp
}

func playtts(kotoba: String) {
    class Delegate: NSObject, AVSpeechSynthesizerDelegate {
            var finished = false
            func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
                finished = true
            }
        }
    let delegate = Delegate()
    let synthesizer = AVSpeechSynthesizer()
    let utterance = AVSpeechUtterance(string: kotoba)
    synthesizer.delegate = delegate
    let lang = get_lang()
    utterance.voice = AVSpeechSynthesisVoice(language: lang)
    utterance.rate = 0.5
    utterance.volume = 1.0
    synthesizer.speak(utterance)
    while !delegate.finished {
            RunLoop.current.run(mode: .default, before: Date().addingTimeInterval(0.1))
        }
}

func add_kotoba(_ item: ktb) -> Bool {
        let cPath = dbPath!.cString(using: .utf8);
        var db: OpaquePointer? = nil
        sqlite3_open(cPath, &db)
        let sql = "INSERT INTO dic (kotoba, kanji, imi, bikou, hinsi) VALUES (?, ?, ?, ?, ?);"
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            return false
        }
        sqlite3_bind_text(stmt, 1, (item.kotoba as NSString).utf8String, -1, nil)
        sqlite3_bind_text(stmt, 2, (item.kanji as NSString).utf8String, -1, nil)
        sqlite3_bind_text(stmt, 3, (item.imi as NSString).utf8String, -1, nil)
        sqlite3_bind_text(stmt, 4, (item.bikou as NSString).utf8String, -1, nil)
        sqlite3_bind_int(stmt, 5, Int32(item.hinsi))
        let result = sqlite3_step(stmt)
        sqlite3_finalize(stmt)
        sqlite3_close(db)
        return result == SQLITE_DONE
    }

func modify_kotoba(_ item: ktb){
    let cPath = dbPath!.cString(using: .utf8);
    var db: OpaquePointer? = nil
        sqlite3_open(cPath, &db)
        let sql = """
        UPDATE dic
        SET kanji = ?, imi = ?, bikou = ?
        WHERE kotoba = ?;
        """
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return }
        sqlite3_bind_text(stmt, 1, (item.kanji as NSString).utf8String, -1, nil)
        sqlite3_bind_text(stmt, 2, (item.imi as NSString).utf8String, -1, nil)
        sqlite3_bind_text(stmt, 3, (item.bikou as NSString).utf8String, -1, nil)
        sqlite3_bind_text(stmt, 4, (item.kotoba as NSString).utf8String, -1, nil)
        let result = sqlite3_step(stmt)
        if result != SQLITE_DONE {}
        sqlite3_finalize(stmt)
        sqlite3_close(db)
}

func delete_kotoba(_ kotoba: String) {
    let cPath = dbPath!.cString(using: .utf8);
        var db: OpaquePointer? = nil
        if sqlite3_open(cPath, &db) != SQLITE_OK { return }
        defer { sqlite3_close(db) }
        let deleteSQL = "DELETE FROM dic WHERE kotoba = ?;"
        var deleteStmt: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteSQL, -1, &deleteStmt, nil) != SQLITE_OK { return }
        sqlite3_bind_text(deleteStmt, 1, (kotoba as NSString).utf8String, -1, nil)
        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            sqlite3_finalize(deleteStmt)
            return
        }
        sqlite3_finalize(deleteStmt)
        let vacuumSQL = "VACUUM;"
        var vacuumStmt: OpaquePointer?
        if sqlite3_prepare_v2(db, vacuumSQL, -1, &vacuumStmt, nil) == SQLITE_OK {
            if sqlite3_step(vacuumStmt) != SQLITE_DONE {}
        }
        sqlite3_finalize(vacuumStmt)
}

func return_count() -> [Int32]{
    var counts: [Int32] = Array(repeating: 0, count: 7)
    let cPath = dbPath!.cString(using: .utf8); // 本番
    var db: OpaquePointer? = nil
    sqlite3_open(cPath, &db)
    let sql = [
            "SELECT count(kotoba) FROM dic;",
            "SELECT count(kotoba) FROM dic WHERE hinsi=0;",
            "SELECT count(kotoba) FROM dic WHERE hinsi=1;",
            "SELECT count(kotoba) FROM dic WHERE hinsi=2;",
            "SELECT count(kotoba) FROM dic WHERE hinsi=3;",
            "SELECT count(kotoba) FROM dic WHERE hinsi=4;",
            "SELECT count(kotoba) FROM dic WHERE hinsi=5;"
        ]
    for (i, query) in sql.enumerated() {
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
        if sqlite3_step(stmt) == SQLITE_ROW {
            counts[i] = Int32(sqlite3_column_int(stmt, 0))
        }
    }
    sqlite3_finalize(stmt)
    }
    sqlite3_close(db)
    return counts
}

func get_lang() -> String {
    let sql = "SELECT lang FROM flag;"
    let cPath = dbPath!.cString(using: .utf8);
    var db: OpaquePointer? = nil
    var lang: String = ""
    if sqlite3_open(cPath, &db) == SQLITE_OK {
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                if let cString = sqlite3_column_text(stmt, 0) {
                    lang = String(cString: cString)
                }
            }
        }
        sqlite3_finalize(stmt)
    }
    sqlite3_close(db)
    return lang
}

func koutyakugo() -> Bool {
    let gengo: String = get_lang()
    if gengo=="ja-JP" || gengo=="ko-KR" {
        return true
    } else {
        return false
    }
}

func return_Study_Int8() -> Int8?{
    let sql = "SELECT kazu FROM flag;"
    guard let cPath = dbPath?.cString(using: .utf8) else { return nil }
    var db: OpaquePointer? = nil
    guard sqlite3_open(cPath, &db) == SQLITE_OK else { return nil }
    defer { sqlite3_close(db) }
    var stmt: OpaquePointer?
    guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return nil }
    defer { sqlite3_finalize(stmt) }
    guard sqlite3_step(stmt) == SQLITE_ROW else { return nil }
    let t = sqlite3_column_int(stmt, 0)
    return Int8(t)
}

func ib() -> Int32 {
    guard let cPath = dbPath?.cString(using: .utf8) else { return 0 }
    var db: OpaquePointer? = nil
    guard sqlite3_open(cPath, &db) == SQLITE_OK else { return 0 }
    let sql = "SELECT COUNT(*) FROM flag;"
    var stmt: OpaquePointer?
    var count: Int32 = 0
    if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
        if sqlite3_step(stmt) == SQLITE_ROW {
            count = sqlite3_column_int(stmt, 0)
        }
    }
    sqlite3_finalize(stmt)
    sqlite3_close(db)
    return count
}

func setup(lang: String, kazu: Int8) {
    guard let cPath = dbPath?.cString(using: .utf8) else { return }
    var db: OpaquePointer? = nil
    guard sqlite3_open(cPath, &db) == SQLITE_OK else { return }
    let count = ib()
    let sql: String
    if count > 0 {
        sql = "UPDATE flag SET lang = ?, kazu = ?;"
    } else {
        sql = "INSERT INTO flag (lang, kazu) VALUES (?, ?);"
    }
    var stmt: OpaquePointer?
    if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
        sqlite3_bind_text(stmt, 1, (lang as NSString).utf8String, -1, nil)
        sqlite3_bind_int(stmt, 2, Int32(kazu))
        if sqlite3_step(stmt) != SQLITE_DONE { }
    }
    sqlite3_finalize(stmt)
    sqlite3_close(db)
}

func study_sql(n: Int8, nx: Int8, sf: Bool = true) -> [ktb] {
    var result: [ktb] = []
    let firstBatch = study_query(limit: n, orderByCount: sf, exclude: [])
    result += firstBatch
    var kotobaSet = Set(result.map { $0.kotoba })
    if sf && nx > 0 {
        var remaining = Int(nx)
        while remaining > 0 {
            let excludeList = Array(kotobaSet)
            let temp = study_query(limit: Int8(remaining), orderByCount: false, exclude: excludeList)
            if temp.isEmpty { break }
            let newlyAdded = temp.filter { !kotobaSet.contains($0.kotoba) }
            if newlyAdded.isEmpty { break }
            result.append(contentsOf: newlyAdded)
            kotobaSet.formUnion(newlyAdded.map { $0.kotoba })
            remaining -= newlyAdded.count
        }
    }
    return result
}

func study_query(limit: Int8, orderByCount: Bool, exclude: [String]) -> [ktb] {
    var result: [ktb] = []
    guard let cPath = dbPath?.cString(using: .utf8) else { return result }
    var db: OpaquePointer? = nil
    if sqlite3_open(cPath, &db) != SQLITE_OK { return result }
    defer { sqlite3_close(db) }
    let placeholders = exclude.map { _ in "?" }.joined(separator: ", ")
    let whereClause = exclude.isEmpty ? "" : "WHERE kotoba NOT IN (\(placeholders))"
    let orderClause = orderByCount ? "ORDER BY count ASC, RANDOM()" : "ORDER BY RANDOM()"
    let sql = """
        SELECT kotoba, hinsi, imi, bikou, kanji, count
        FROM dic
        \(whereClause)
        \(orderClause)
        LIMIT ?;
    """
    var stmt: OpaquePointer? = nil
    guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return result }
    defer { sqlite3_finalize(stmt) }
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    for (i, word) in exclude.enumerated() {
        sqlite3_bind_text(stmt, Int32(i + 1), (word as NSString).utf8String, -1, SQLITE_TRANSIENT)
    }
    sqlite3_bind_int(stmt, Int32(exclude.count + 1), Int32(limit))
    while sqlite3_step(stmt) == SQLITE_ROW {
        let kotoba = String(cString: sqlite3_column_text(stmt, 0))
        let hinsi = Int8(sqlite3_column_int(stmt, 1))
        let imi = String(cString: sqlite3_column_text(stmt, 2))
        let bikou = String(cString: sqlite3_column_text(stmt, 3))
        let kanji = String(cString: sqlite3_column_text(stmt, 4))
        let count = Int8(sqlite3_column_int(stmt, 5))
        let item = ktb(
            kotoba: kotoba,
            imi: imi,
            bikou: bikou,
            kanji: kanji,
            hinsi: hinsi,
            count: count
        )
        result.append(item)
    }
    return result
}

func gen_study() -> ([ktb], Int8)? {
    guard var all = return_Study_Int8() else {
        return nil
    }
    let tl = return_count()
    if all > tl[0] { all = Int8(tl[0]) }
    let nw = Int8(Double(all) * 0.6)
    let od = all - nw
    let tmp: [ktb] = study_sql(n: nw, nx: od)
    return (tmp, all)
}

func update_count(up: ktb) {
    var db: OpaquePointer? = nil
    if sqlite3_open(dbPath, &db) != SQLITE_OK { return }
    defer { sqlite3_close(db) }
    let sql = "UPDATE dic SET count = ? WHERE kotoba = ?;"
    var stmt: OpaquePointer? = nil
    if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
        sqlite3_bind_int(stmt, 1, Int32(up.count))
        sqlite3_bind_text(stmt, 2, (up.kotoba as NSString).utf8String, -1, nil)
        if sqlite3_step(stmt) != SQLITE_DONE {}
    }
    sqlite3_finalize(stmt)
}

func get_study_pro() -> [Int]{
    var db: OpaquePointer? = nil
    var stmt: OpaquePointer? = nil
    let queries = [
            "SELECT count(kotoba) FROM dic WHERE count=0;",
            "SELECT count(kotoba) FROM dic WHERE count=1;",
            "SELECT count(kotoba) FROM dic WHERE count>=2;"
        ]
    var tmp = [0, 0, 0]
    if sqlite3_open(dbPath, &db) != SQLITE_OK { return tmp }
        defer { sqlite3_close(db) }
    for (i, sql) in queries.enumerated() {
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                let value = Int(sqlite3_column_int(stmt, 0))
                tmp[i] = value
            }
        }
        sqlite3_finalize(stmt)
    }
    return tmp
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

func get_study_count(for kotoba: String) -> Int? {
    var db: OpaquePointer? = nil
    var stmt: OpaquePointer? = nil
    var result: Int? = nil
    if sqlite3_open(dbPath, &db) != SQLITE_OK { return nil }
    defer {
        sqlite3_finalize(stmt)
        sqlite3_close(db)
    }
    let sql = "SELECT count FROM dic WHERE kotoba=?;"
    if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK { return nil }
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    if sqlite3_bind_text(stmt, 1, kotoba, -1, SQLITE_TRANSIENT) != SQLITE_OK { return nil }
    if sqlite3_step(stmt) == SQLITE_ROW {
        result = Int(sqlite3_column_int(stmt, 0))
    }
    return result
}

func requestNotificationPermission() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {}
    }
}

func schedule() {
    let content = UNMutableNotificationContent()
    content.title = "FolygonDic"
    content.body = "Let’s study the words!".localized
    content.sound = .default
    var dateComponents = DateComponents()
    dateComponents.hour = 12
    dateComponents.minute = 0
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(identifier: "noonNotification", content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {}
    }
}
