import SwiftUI

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var kotobaList: [ktb] = []
    @State private var selectedItem: ktb? = nil
    @State private var showingPieModal: Bool = false
    @State private var showingAddModal: Bool = false
    @State private var flag = false
    @State private var delete_flag = false
    @State private var showinitModal = false
    @State private var isPortraitState: Bool? = nil
    var body: some View {
        GeometryReader { geometry in
            let isPortrait = geometry.size.height > geometry.size.width
            let topBarHeight = geometry.size.height * 0.1
            let listViewHeight = geometry.size.height * 0.9
            Group {
                if geometry.size.width < 700 || (geometry.size.width >= 700 && isPortrait) {
                    VStack(spacing: 0) {
                        topBar
                            .frame(height: topBarHeight)
                        kotobaListView
                            .frame(height: listViewHeight)
                    }
                    .sheet(item: $selectedItem) { item in
                        ModalView(delf: $delete_flag, item: item)
                    }
                    .sheet(isPresented: $showingPieModal) {
                        PieChartModal()
                    }
                    .sheet(isPresented: $showingAddModal, onDismiss: {
                        if flag {
                            search()
                            flag = false
                        }
                    }) {
                        AddModalView(flag: $flag)
                    }
                    .onChange(of: delete_flag) { newValue in
                        if newValue {
                            search()
                            selectedItem = nil
                            delete_flag = false
                        }
                    }
                } else {
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            topBar
                                .frame(height: topBarHeight)
                            kotobaListView
                                .frame(height: listViewHeight)
                        }
                        .frame(width: geometry.size.width * 0.5)
                        Divider()
                        if let item = selectedItem {
                            SideDetailView(delf: $delete_flag, selectedItem: $selectedItem, item: item)
                                .frame(width: geometry.size.width * 0.5)
                        } else {
                            Color.clear
                        }
                    }
                    .sheet(isPresented: $showingPieModal) {
                        PieChartModal()
                    }
                    .sheet(isPresented: $showingAddModal, onDismiss: {
                        if flag {
                            search()
                            flag = false
                        }
                    }) {
                        AddModalView(flag: $flag)
                    }
                    .onChange(of: delete_flag) { newValue in
                        if newValue {
                            search()
                            delete_flag = false
                        }
                    }
                }
            }
            .task {
                if isPortraitState == nil {
                    isPortraitState = isPortrait
                }
            }
            .onChange(of: geometry.size) { _ in
                let current = geometry.size.height > geometry.size.width
                if let prev = isPortraitState {
                    if prev == true && current == false {
                        search()
                    }
                }
                isPortraitState = current
            }
        }
        .onAppear {
            let dbDirPath: String? = dbPath
            if let dbDirPath {
                if !fileManager.fileExists(atPath: dbDirPath) {
                    make_db()
                }
            }
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                    if ib() != 0 {
                        timer.invalidate()
                    } else {
                        showinitModal = true
                    }
                }
            requestNotificationPermission()
            schedule()
            search()
            let ulist = PhoneSessionManager.shared.getReceivedList()
            let tn = ulist.count
            if tn != 0 {
                for i in 0..<tn {
                    var kazu: Int
                    if ulist[i].cal_count {
                        kazu = get_study_count(for: ulist[i].kotoba)! + 1
                    } else {
                        kazu = 0
                    }
                    let t = ktb(kotoba: ulist[i].kotoba, imi: "", bikou: "", kanji: "", hinsi: 0, count: Int8(kazu))
                    update_count(up: t)
                }
            }
            if let (list, _) = gen_study() {
                watch_queue(list)
            }
        }
        .sheet(isPresented: $showinitModal) {
            initModalView(showModal: $showinitModal)
                }
    }
    var topBar: some View {
        HStack {
            Button(action: search) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                    .font(.system(size: 30))
            }
            TextField("Input".localized, text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.done)
                                .onSubmit {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                                    to: nil, from: nil, for: nil)
                                    search()
                                }
            Button(action: _add){
                Image(systemName: "plus.app")
                    .foregroundColor(.black)
                    .font(.system(size: 30))
            }
            Button(action: pieView){
                Image(systemName: "chart.pie")
                    .foregroundColor(.black)
                    .font(.system(size: 30))
            }
        }
        .padding(.horizontal)
    }
    var kotobaListView: some View {
        List(kotobaList, id: \.kotoba) { item in
            Text(!item.kanji.elementsEqual(item.kotoba) ? "\(item.kanji) \(item.kotoba)" : item.kotoba)
                .onTapGesture {
                    out_view(item: item)
                }
        }
        .scrollContentBackground(.hidden)
        .background(Color.blue.opacity(0.05))
        .animation(.default, value: kotobaList)
    }
    func search() {
        withAnimation {
            kotobaList.removeAll()
        }
        let newItems = sagasu(kotoba: inputText)
        withAnimation {
            kotobaList = newItems
        }
    }
    func out_view(item: ktb) {
            selectedItem = item
    }
    func pieView() {
        showingPieModal = true
    }
    func _add() {
        showingAddModal = true
    }
}

struct ModalView: View {
    @Binding var delf: Bool
    @State private var showAlert = false
    var f: Bool = false
    @State private var showModify: Bool = false
    let item: ktb
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 0) {
            Text(detailText)
                .font(.title3)
                .frame(maxHeight: .infinity, alignment: .center)
                .padding()
            HStack {
                Button(action: _play) {
                    Image(systemName: "play.circle")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                } .padding().background(.ultraThinMaterial).clipShape(Circle()).shadow(radius: 3)
                Button(action: _modify) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                } .padding().background(.ultraThinMaterial).clipShape(Circle()).shadow(radius: 3)
                Button(action: _delete) {
                    Image(systemName: "trash")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                } .padding().background(.ultraThinMaterial).clipShape(Circle()).shadow(radius: 3)
            }
            Spacer(minLength: 1)
            .frame(height: 50)
            .alert("Are you sure you want to delete this?".localized, isPresented: $showAlert) {
                Button("Ok".localized, role: .destructive) {
                    delete_kotoba(item.kotoba)
                    delf = true
                    }
                Button("No".localized, role: .cancel) { }
            }
            .sheet(isPresented: $showModify) {
                ModifyModalView(original: item, flag: $delf)
            }
        }
    }
    private var detailText: String {
        var hinsi: String
        switch item.hinsi {
            case 0:
                hinsi = koutyakugo() ? "[Particle]".localized : "[Preposition]".localized
            case 1:
                hinsi = "[Noun]".localized
            case 2:
                hinsi = "[Verb]".localized
            case 3:
                hinsi = "[Adjective]".localized
            case 4:
                hinsi = "[Adverb]".localized
            default:
                hinsi = "[Others]".localized
        }
        let title = item.kanji.elementsEqual(item.kotoba) ? item.kotoba : "\(item.kanji) \(item.kotoba)"
        return "\(title)\n\(hinsi)\n\(item.imi)\n\(item.bikou)"
    }
    func _play(){
        playtts(kotoba: item.kotoba)
    }
    func dummy(){}
    func _delete(){
        showAlert = true
    }
    func _modify(){
        showModify = true
    }
}

struct SideDetailView: View {
    @Binding var delf: Bool
    @Binding var selectedItem: ktb?
    @State private var showAlert = false
    @State private var showModify: Bool = false
    let item: ktb
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Text(detailText)
                    .font(.title3)
                    .frame(height: geo.size.height * 0.9)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                HStack {
                    Button(action: _play) {
                        Image(systemName: "play.circle")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                    } .padding().background(.ultraThinMaterial).clipShape(Circle()).shadow(radius: 3)
                    Button(action: _modify) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                    } .padding().background(.ultraThinMaterial).clipShape(Circle()).shadow(radius: 3)
                    Button(action: _delete) {
                        Image(systemName: "trash")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                    } .padding().background(.ultraThinMaterial).clipShape(Circle()).shadow(radius: 3)
                }
                .frame(height: geo.size.height * 0.1)
                .alert("Are you sure you want to delete this?".localized, isPresented: $showAlert) {
                    Button("Ok".localized, role: .destructive) {
                            delete_kotoba(item.kotoba)
                            delf = true
                            selectedItem = nil
                        }
                    Button("No".localized, role: .cancel) { }
                }
                .sheet(isPresented: $showModify, onDismiss: {
                    if delf {
                        selectedItem = nil
                    }
                }) {
                    ModifyModalView(original: item, flag: $delf)
                }
                .onChange(of: delf) { newValue in
                    if newValue {
                        selectedItem = nil
                    }
                }
            }
        }
    }
    private var detailText: String {
        var hinsi: String
        switch item.hinsi {
            case 0:
                hinsi = koutyakugo() ? "[Particle]".localized : "[Preposition]".localized
            case 1:
                hinsi = "[Noun]".localized
            case 2:
                hinsi = "[Verb]".localized
            case 3:
                hinsi = "[Adjective]".localized
            case 4:
                hinsi = "[Adverb]".localized
            default:
                hinsi = "[Others]".localized
        }
        let title = item.kanji.elementsEqual(item.kotoba) ? item.kotoba : "\(item.kanji) \(item.kotoba)"
        return "\(title)\n\(hinsi)\n\(item.imi)\n\(item.bikou)"
    }
    func _play(){
        playtts(kotoba: item.kotoba)
    }
    func dummy(){}
    func _delete(){
        showAlert=true
    }
    func _modify(){
        showModify = true
    }
}

struct PieChartModal: View {
    @State private var showStudyModal = false
    @State private var showinitModal = false
    @State private var showstudypie = false
    let counts: [Int32]
    private let labels: [String] = [
        "Total".localized, koutyakugo() ? "Particle".localized : "Preposition".localized, "Noun".localized, "Verb".localized, "Adjective".localized, "Adverb".localized, "Others".localized
    ]
    private let colors: [Color] = [.yellow, .green, .cyan, .orange, .purple, .red]
    init(counts: [Int32] = return_count()) {
        self.counts = counts
    }
    var body: some View {
        let values = (1...6).map { Double(counts[$0]) }
        let total = values.reduce(0, +)
        VStack(spacing: 16) {
            HStack {
                Spacer(minLength: 1)
                Text(String(format: "Total:".localized,
                            "\(counts[0])"))
                    .font(.title2)
                Spacer(minLength: 3)
                Button(action: study) {
                    Text("Study".localized)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 45, height: 12)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(8)
                Button(action: studypie) {
                    Image(systemName: "chart.pie")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                }
                Spacer(minLength: 1)
                Button(action: init_) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                    }
            } .padding(.top)
            ZStack {
                ForEach(0..<6, id: \.self) { i in
                    let startFraction = total > 0 ? values.prefix(i).reduce(0, +) / total : 0
                    let sliceFraction = total > 0 ? values[i] / total : 0
                    PieSlice(
                        startAngle: Angle(degrees: -90 + startFraction * 360.0),
                        endAngle: Angle(degrees: -90 + (startFraction + sliceFraction) * 360.0)
                    )
                    .fill(colors[i % colors.count])
                }
                ForEach(0..<6, id: \.self) { i in
                    let startFraction = total > 0 ? values.prefix(i).reduce(0, +) / total : 0
                    let sliceFraction = total > 0 ? values[i] / total : 0
                    let percent = sliceFraction * 100.0
                    if percent >= 3.0 {
                        GeometryReader { geo in
                            let radius = min(geo.size.width, geo.size.height) / 2
                            let midAngleDeg = -90.0 + (startFraction + sliceFraction / 2.0) * 360.0
                            let rad = midAngleDeg * .pi / 180.0
                            let r = radius * 0.6
                            let x = geo.size.width / 2 + CGFloat(cos(rad)) * r
                            let y = geo.size.height / 2 + CGFloat(sin(rad)) * r
                            Text(String(format: "%.0f%%", percent))
                                .font(.caption.bold())
                                .foregroundStyle(Color.white)
                                .shadow(radius: 2)
                                .position(x: x, y: y)
                        }
                    }
                }
            }
            .padding()
            .aspectRatio(1, contentMode: .fit)
            LegendView(values: values, total: total)
        }
        .padding()
        .sheet(isPresented: $showinitModal) {
                    initModalView(showModal: $showinitModal)
        }
        .sheet(isPresented: $showStudyModal) {
                    studyModal()
        }
        .sheet(isPresented: $showstudypie) {
                    study_pie()
        }
    }
    @ViewBuilder
    private func LegendView(values: [Double], total: Double) -> some View {
        let cols = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]
        LazyVGrid(columns: cols, spacing: 8) {
            ForEach(0..<6, id: \.self) { i in
                let label = labels[i + 1]
                let color = colors[i % colors.count]
                let count = Int(values[i])
                let percent = total > 0 ? values[i] / total * 100.0 : 0
                HStack(spacing: 8) {
                    Circle()
                        .fill(color)
                        .frame(width: 12, height: 12)
                    Text("\(label) \(count) (\(String(format: "%.0f%%", percent)))")
                        .font(.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding(.horizontal)
    }
    func init_(){
        showinitModal = true
    }
    func study(){
        showStudyModal = true
    }
    func studypie(){
        showstudypie = true
    }
}

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(center: center,
                    radius: min(rect.width, rect.height) / 2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        path.closeSubpath()
        return path
    }
}

struct AddModalView: View {
    @State private var kotoba: String = ""
    @State private var kanji: String = ""
    @State private var imi: String = ""
    @State private var bikou: String = ""
    @State private var hinsi: String? = nil
    @Binding var flag: Bool
    @State private var showDuplicateAlert1 = false
    @State private var showDuplicateAlert2 = false
    let lang: String = get_lang()
    let items = [
        koutyakugo() ? "Particle".localized : "Preposition".localized, "Noun".localized, "Verb".localized, "Adjective".localized, "Adverb".localized, "Others".localized
    ]
    var body: some View {
            VStack {
                Text("Add Word".localized)
                .font(.title)
                .padding()
            if lang == "ja-JP" || lang == "zh-TW" || lang == "zh-CN" {
                HStack {
                    TextField("Enter a word".localized, text: $kotoba)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .contentShape(Rectangle())
                            .onTapGesture {
                                hideKeyboard()
                            }
                    Button(action: _addKotoba){
                        Image(systemName: "plus.app")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                    }
                } .padding()
                HStack {
                    Menu {
                        ForEach(items, id: \.self) { item in
                            Button(item) { hinsi = item }
                        }
                    } label: {
                        Text(hinsi ?? "Part of Speech".localized)
                            .foregroundColor(hinsi == nil ? .gray : .primary)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    } .padding()
                    TextField("Kanji".localized, text: $kanji)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            hideKeyboard()
                        }
                } .padding()
            } else {
                HStack {
                    Menu {
                        ForEach(items, id: \.self) { item in
                            Button(item) { hinsi = item }
                        }
                    } label: {
                        Text(hinsi ?? "Part of Speech".localized)
                            .foregroundColor(hinsi == nil ? .gray : .primary)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    } .padding()
                    TextField("Enter a word".localized, text: $kotoba)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .contentShape(Rectangle()) // VStack 전체 영역 터치 가능하게
                            .onTapGesture {
                                hideKeyboard()
                            }
                    Button(action: _addKotoba){
                        Image(systemName: "plus.app")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                    }
                } .padding()
            }
                TextField("Enter meaning".localized, text: $imi, axis: .vertical)
                    .lineLimit(4)
                        .padding(8)
                        .frame(minHeight: 44, maxHeight: 44 * 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .contentShape(Rectangle())
                                .onTapGesture {
                                    hideKeyboard()
                                }
                TextField("Notes".localized, text: $bikou, axis: .vertical)
                    .lineLimit(3)
                        .padding(8)
                        .frame(minHeight: 44, maxHeight: 44 * 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .contentShape(Rectangle())
                                .onTapGesture {
                                    hideKeyboard()
                                }
        }
            .alert("This word already exists.".localized, isPresented: $showDuplicateAlert1) { Button("Ok".localized, role: .cancel) { } }
            .alert("Enter a word".localized, isPresented: $showDuplicateAlert2) { Button("Ok".localized, role: .cancel) { } }
    }
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    func _addKotoba() {
        if kotoba.isEmpty {
            showDuplicateAlert2 = true
            return
        }
        var h: Int8 = 0
        switch hinsi{
            case koutyakugo() ? "Particle".localized : "Preposition".localized:
                h = 0
            case "Noun".localized:
                h = 1
            case "Verb".localized:
                h = 2
            case "Adjective".localized:
                h = 3
            case "Adverb".localized:
                h = 4
            default :
                h = 5
        }
        let f: Bool = add_kotoba(ktb(kotoba: kotoba, imi: imi, bikou: bikou, kanji: kanji, hinsi: h))
        if f {
            flag = true
        } else {
            showDuplicateAlert1 = true
        }
    }
}

struct ModifyModalView: View {
    var original: ktb
    @Binding var flag: Bool
    @State private var kotoba: String = ""
    @State private var kanji: String = ""
    @State private var imi: String = ""
    @State private var bikou: String = ""
    @State private var hinsi: String = ""
    init(original: ktb, flag: Binding<Bool>) {
            self.original = original
            self._flag = flag
            _kotoba = State(initialValue: original.kotoba)
            _kanji  = State(initialValue: original.kanji)
            _imi    = State(initialValue: original.imi)
            _bikou  = State(initialValue: original.bikou)
            var h: String
            switch original.hinsi {
            case 0:
                h = koutyakugo() ? "Particle".localized : "Preposition".localized
            case 1:
                h = "Noun".localized
            case 2:
                h = "Verb".localized
            case 3:
                h = "Adjective".localized
            case 4:
                h = "Adverb".localized
            default:
                h = "Others".localized
            }
            _hinsi = State(initialValue: h)
        }
    let lang: String = get_lang()
        let items = [
            koutyakugo() ? "Particle".localized : "Preposition".localized,
            "Noun".localized, "Verb".localized, "Adjective".localized,
            "Adverb".localized, "Others".localized
        ]
    var body: some View {
        VStack {
            Text("Modify Word".localized)
                .font(.title)
                .padding()
            if lang == "ja-JP" || lang == "zh-TW" || lang == "zh-CN" {
                HStack {
                    TextField("Enter a word".localized, text: $kotoba)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .contentShape(Rectangle()) // VStack 전체 영역 터치 가능하게
                        .disabled(true)
                    Button(action: modify){
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                    }
                } .padding()
                HStack {
                    Text(hinsi)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    TextField("Kanji".localized, text: $kanji)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            hideKeyboard()
                        }
                        .padding()
                } .padding()
            } else {
                HStack {
                    Text(hinsi)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    TextField("Enter a word".localized, text: $kotoba)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .contentShape(Rectangle())
                        .disabled(true)
                    Button(action: modify){
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                    } .padding()
                } .padding()
            }
            TextField("Enter meaning".localized, text: $imi, axis: .vertical)
                .lineLimit(4)
                    .padding(8)
                    .frame(minHeight: 44, maxHeight: 44 * 4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .contentShape(Rectangle())
                            .onTapGesture {
                                hideKeyboard()
                            }
            TextField("Notes".localized, text: $bikou, axis: .vertical)
                .lineLimit(3)
                    .padding(8)
                    .frame(minHeight: 44, maxHeight: 44 * 4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .contentShape(Rectangle())
                            .onTapGesture {
                                hideKeyboard()
                            }
        }
    }
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    func modify(){
        var tmp = ktb(kotoba: original.kotoba,
                      imi: imi,
                      bikou: bikou,
                      kanji: kanji,
                      hinsi: original.hinsi)
        modify_kotoba(tmp)
        flag = true
    }
}

struct initModalView: View {
    @State private var gengo: String? = nil
    @State private var study_value: Int8 = 20
    @Binding var showModal: Bool
    let items = ["Japanese".localized, "Korean".localized, "English".localized, "Russian".localized, "Chinese".localized, "Spanish".localized]
    let lang: [String : String] = ["Japanese".localized : "ja-JP", "Korean".localized : "ko-KR", "English".localized : "en-US", "Russian".localized : "ru-RU", "Chinese".localized : "zh-CN", "Spanish".localized : "es-ES"]
    var body: some View {
        VStack {
            HStack {
                Menu {
                    ForEach(items, id: \.self) { item in
                        Button(item) { gengo = item }
                    }
                } label: {
                    Text(gengo ?? "Language".localized)
                        .foregroundColor(gengo == nil ? .gray : .primary)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                } .padding()
                Button(action: set_) {
                    Text("Apply".localized)
                } .padding()
            }
            HStack{
                Text("Words per Session :".localized).font(.subheadline)
                Button(action: {
                                if study_value > 10 { study_value -= 5 }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                            }

                            TextField("", value: $study_value, formatter: NumberFormatter())
                                .frame(width: 60)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .disabled(true)

                        Button(action: {
                                if study_value < 100 { study_value += 5 }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                            }
            }
            if ProcessInfo.processInfo.isMacCatalystApp {
                Text(documentsURL!.path)
                    .foregroundColor(.blue)
                    .underline()
                    .onTapGesture {
                        UIApplication.shared.open(documentsURL!)
                    }
            }
        }
    }
    func set_(){
        if gengo == nil {
            return
        }
        setup(lang: lang[gengo!]!, kazu: study_value)
        showModal = false
    }
}

struct studyModal: View {
    var slist: [ktb]
    var n: Int8 = 0
    @State var cnt: Int = 0
    var finish: Bool = false
    @State private var showText = false
    @Environment(\.dismiss) private var dismiss
    init() {
        if let (list, total) = gen_study() {
            self.slist = list
            self.n = total
        } else {
            self.slist = []
            self.n = 0
        }
    }
    var body: some View {
        VStack {
            Text(slist[cnt].kotoba == slist[cnt].kanji ? slist[cnt].kotoba : (slist[cnt].kanji + " " + slist[cnt].kotoba))
                .font(.title)
            Text(showText ? (slist[cnt].imi + "\n" + slist[cnt].bikou) : "[View Meaning]".localized) // 처음엔 공백
                .foregroundColor(showText ? .black : .blue)
                .padding()
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showText.toggle()
                    }
                }
            HStack {
                Button(action: no_ok){
                    Image(systemName: "x.circle")
                        .foregroundColor(.red)
                        .font(.system(size: 60))
                }
                Button(action: _play) {
                    Image(systemName: "play.circle")
                        .foregroundColor(.black)
                        .font(.system(size: 60))
                }
                Button(action: yes_ok){
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                        .font(.system(size: 60))
                }
            }
        }
    }
    func yes_ok(){
        var tmp = slist[cnt]
        tmp.count += 1
        update_count(up: tmp)
        next()
    }
    func _play(){
        playtts(kotoba: slist[cnt].kotoba)
    }
    func no_ok(){
        var tmp = slist[cnt]
        if tmp.count > 0 {
            tmp.count = 0
        }
        update_count(up: tmp)
        next()
    }
    func next(){
        showText = false
        if cnt < n - 1 {
            cnt += 1
        } else {
            dismiss()
        }
    }
}

struct study_pie: View {
    let counts: [Int]
    private let labels: [String] = [
        "[not remember]".localized, "[remember]".localized, "[remember perfectly]".localized
    ]
    private let colors: [Color] = [.yellow, .green, .cyan]
    init(counts: [Int] = get_study_pro()) {
        self.counts = counts
    }
    var body: some View {
        let values = (0...2).map { Double(counts[$0]) }
        let total = values.reduce(0, +)
        VStack(spacing: 16) {
            HStack {
                Text(String(format: "Study Progress".localized))
                    .font(.title2)
            }
            ZStack {
                ForEach(0..<3, id: \.self) { i in
                    let startFraction = total > 0 ? values.prefix(i).reduce(0, +) / total : 0
                    let sliceFraction = total > 0 ? values[i] / total : 0
                    PieSlice(
                        startAngle: Angle(degrees: -90 + startFraction * 360.0),
                        endAngle: Angle(degrees: -90 + (startFraction + sliceFraction) * 360.0)
                    )
                    .fill(colors[i % colors.count])
                }
                ForEach(0..<3, id: \.self) { i in
                    let startFraction = total > 0 ? values.prefix(i).reduce(0, +) / total : 0
                    let sliceFraction = total > 0 ? values[i] / total : 0
                    let percent = sliceFraction * 100.0
                    if percent >= 3.0 {
                        GeometryReader { geo in
                            let radius = min(geo.size.width, geo.size.height) / 2
                            let midAngleDeg = -90.0 + (startFraction + sliceFraction / 2.0) * 360.0
                            let rad = midAngleDeg * .pi / 180.0
                            let r = radius * 0.6
                            let x = geo.size.width / 2 + CGFloat(cos(rad)) * r
                            let y = geo.size.height / 2 + CGFloat(sin(rad)) * r
                            Text(String(format: "%.0f%%", percent))
                                .font(.caption.bold())
                                .foregroundStyle(Color.white)
                                .shadow(radius: 2)
                                .position(x: x, y: y)
                        }
                    }
                }
            }
            .padding()
            .aspectRatio(1, contentMode: .fit)
            LegendView(values: values, total: total)
        }
        .padding()
    }
    @ViewBuilder
    private func LegendView(values: [Double], total: Double) -> some View {
        let cols = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]
        LazyVGrid(columns: cols, spacing: 8) {
            ForEach(0..<3, id: \.self) { i in
                let label = labels[i]
                let color = colors[i % colors.count]
                let count = Int(values[i])
                let percent = total > 0 ? values[i] / total * 100.0 : 0
                HStack(spacing: 8) {
                    Circle()
                        .fill(color)
                        .frame(width: 12, height: 12)
                    Text("\(label) \(count) (\(String(format: "%.0f%%", percent)))")
                        .font(.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding(.horizontal)
    }
}
