import WatchConnectivity

struct sktb: Codable, Hashable, Identifiable {
    var id: String { kotoba }
    var kotoba: String
    var cal_count: Bool
}

func watch_queue(_ list: [ktb]) {
    guard WCSession.isSupported() else { return }
    let session = WCSession.default
    let encoder = JSONEncoder()
    guard let jsonData = try? encoder.encode(list) else { return }
    for transfer in session.outstandingUserInfoTransfers {
            transfer.cancel()
        }
    let payload: [String: Any] = [
            "queuedKtbArray": jsonData,
            "extraMessage": get_lang(),
        ]
    session.transferUserInfo(payload)
}

class PhoneSessionManager: NSObject, WCSessionDelegate {
    static let shared = PhoneSessionManager()
    private var receivedList: [sktb] = []
    private let saveKey = "receivedKtbList"
    override init() {
        super.init()
        loadReceivedList()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let data = userInfo["watchsKtbArray"] as? Data {
            if let list = try? JSONDecoder().decode([sktb].self, from: data) {
                self.receivedList = list
                saveReceivedList()
            }
        }
    }
    func getReceivedList() -> [sktb] {
        let list = receivedList
        receivedList.removeAll()
        UserDefaults.standard.removeObject(forKey: saveKey)
        return list
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    func sessionReachabilityDidChange(_ session: WCSession) {}
    private func saveReceivedList() {
        if let data = try? JSONEncoder().encode(receivedList) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
    private func loadReceivedList() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let list = try? JSONDecoder().decode([sktb].self, from: data) {
            receivedList = list
        }
    }
}
