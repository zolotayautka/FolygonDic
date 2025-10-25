import WatchConnectivity
import Combine
import AVFoundation

struct ktb: Codable, Hashable, Identifiable {
    var id: String { kotoba }
    var kotoba: String
    var imi: String
    var bikou: String
    var kanji: String
    var hinsi: Int8
    var count: Int8 = 0
}

struct sktb: Codable, Hashable, Identifiable {
    var id: String { kotoba }
    var kotoba: String
    var cal_count: Bool
}

class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    @Published private(set) var receivedList: [ktb] = []
    @Published private(set) var receivedMessage: String = ""
    override init() {
        super.init()
        loadReceivedData()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        var newList: [ktb] = []
        var newMessage: String = ""
        if let data = userInfo["queuedKtbArray"] as? Data,
           let list = try? JSONDecoder().decode([ktb].self, from: data) {
            newList = list
        }
        if let msg = userInfo["extraMessage"] as? String {
            newMessage = msg
        }
        guard !newList.isEmpty || !newMessage.isEmpty else { return }
        clearSavedData()
        DispatchQueue.main.async {
            self.receivedList = newList
            self.receivedMessage = newMessage
            self.saveReceivedData()
        }
    }
    func getReceivedList() -> [ktb] { receivedList }
    func getReceivedlang() -> String { receivedMessage }
    private func saveReceivedData() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(receivedList) {
            UserDefaults.standard.set(data, forKey: "receivedList")
        }
        UserDefaults.standard.set(receivedMessage, forKey: "receivedMessage")
    }
    private func loadReceivedData() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "receivedList"),
           let list = try? decoder.decode([ktb].self, from: data) {
            self.receivedList = list
        }
        if let msg = UserDefaults.standard.string(forKey: "receivedMessage") {
            self.receivedMessage = msg
        }
        if !receivedList.isEmpty || !receivedMessage.isEmpty { }
    }
    private func clearSavedData() {
        UserDefaults.standard.removeObject(forKey: "receivedList")
        UserDefaults.standard.removeObject(forKey: "receivedMessage")
        receivedList.removeAll()
        receivedMessage = ""
    }
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}
    func sessionReachabilityDidChange(_ session: WCSession) {}
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
    let lang = WatchSessionManager.shared.getReceivedlang()
    utterance.voice = AVSpeechSynthesisVoice(language: lang)
    utterance.rate = 0.5
    utterance.volume = 1.0
    synthesizer.speak(utterance)
    while !delegate.finished {
        RunLoop.current.run(mode: .default, before: Date().addingTimeInterval(0.1))
    }
}

func send_return(_ list: [sktb]) {
    guard WCSession.isSupported() else { return }
    let session = WCSession.default
    if session.activationState != .activated {
        session.delegate = nil
        session.activate()
    }
    let kotobaArray = list.map { $0.kotoba }
    struct Static {
        static var lastSentKotobaArray: [String]?
    }
    if kotobaArray == Static.lastSentKotobaArray { return }
    let encoder = JSONEncoder()
    guard let jsonData = try? encoder.encode(list) else { return }
    for transfer in session.outstandingUserInfoTransfers {
        transfer.cancel()
    }
    session.transferUserInfo(["watchsKtbArray": jsonData])
    Static.lastSentKotobaArray = kotobaArray
}

