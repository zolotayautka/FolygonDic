import SwiftUI

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

struct ContentView: View {
    @State private var showStudyModal = false
    var body: some View {
        VStack {
            Text("Study".localized)
            Button(action: _start) {
                Image(systemName: "arrow.right.circle")
                    .foregroundColor(.black)
                    .font(.system(size: 30))
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(Circle())
            .shadow(radius: 3)
        }
        .padding()
        .sheet(isPresented: $showStudyModal) {
            StudyModal()
        }
    }
    private func _start() {
        showStudyModal = true
    }
}

struct StudyModal: View {
    var slist: [ktb]
    @State var clist: [sktb] = []
    var n: Int8 = 0
    @State var cnt: Int = 0
    var finish: Bool = false
    @State private var showText = false
    @Environment(\.dismiss) private var dismiss
    var f: Bool = false
    init() {
        let list = WatchSessionManager.shared.getReceivedList()
        self.slist = list
        self.n = Int8(list.count)
    }
    var body: some View {
        VStack {
            if !slist.isEmpty && cnt < slist.count {
                Text(slist[cnt].kotoba == slist[cnt].kanji ? slist[cnt].kotoba : slist[cnt].kanji + " " + slist[cnt].kotoba)
                    .font(.headline)

                Text(showText ? (slist[cnt].imi + "\n" + slist[cnt].bikou) : "[View Meaning]".localized)
                    .foregroundColor(showText ? .white : .blue)
                    .padding()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showText.toggle()
                        }
                    }
                HStack {
                    Button(action: no_ok) {
                        Image(systemName: "x.circle")
                            .foregroundColor(.red)
                            .font(.system(size: 40))
                    }
                    Button(action: _play) {
                        Image(systemName: "play.circle")
                            .foregroundColor(.black)
                            .font(.system(size: 40))
                    }
                    Button(action: yes_ok) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                            .font(.system(size: 40))
                    }
                }
            } else {
                Text("No items received")
                    .font(.headline)
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
    func yes_ok(){
        let t: sktb = sktb(kotoba: slist[cnt].kotoba, cal_count: true)
        clist.append(t)
        next()
    }
    func _play(){
        playtts(kotoba: slist[cnt].kotoba)
    }
    func no_ok(){
        let t: sktb = sktb(kotoba: slist[cnt].kotoba, cal_count: false)
        clist.append(t)
        next()
    }
    func next(){
        showText = false
        if cnt < Int(n) - 1 {
            cnt += 1
        } else {
            send_return(clist)
            dismiss()
        }
    }
}
