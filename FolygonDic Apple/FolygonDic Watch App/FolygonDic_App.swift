import SwiftUI

@main
struct FolygonDic__Watch_AppApp: App {
    @StateObject var sessionManager = WatchSessionManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
