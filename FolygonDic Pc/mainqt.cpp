#include "mainqt.h"
#include "ui_mainqt.h"

QLocale locale;
QString loc = locale.name();

bool fileExists(const std::string& filePath) {
    struct stat buffer;
    return (stat(filePath.c_str(), &buffer) == 0);
}

mainQT::mainQT(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::mainQT)
{
    ui->setupUi(this);
    setFixedSize(QSize(821, 561));
    bool k = true;
    QString t = QDir::homePath() + "/Dictionary";
    if (!(fileExists(t.toStdString()))){
        do{
            init = new new_dic(&k);
            init->exec();
            delete init;
        }while(k);
    }
    koutyakugo_f = koutyakugo();
    connect(ui->sagasu_btn, &QPushButton::clicked, this, &mainQT::sagasu);
    connect(ui->sagasu_list, &QListWidget::clicked, this, &mainQT::imi_out);
    connect(ui->sagasu_list, &QListWidget::currentItemChanged, this, &mainQT::imi_out);
    connect(ui->mp3_btn, &QPushButton::clicked, this, &mainQT::play_mp3);
    connect(ui->add_kotoba_btn, &QPushButton::clicked, this, &mainQT::_add);
    connect(ui->modify_kotoba_btn, &QPushButton::clicked, this, &mainQT::_modify);
    connect(ui->del_kotoba_btn, &QPushButton::clicked, this, &mainQT::_del);
    connect(ui->tab, &QTabWidget::currentChanged, this, &mainQT::tab_henkou);
    connect(ui->sel_pi, &QComboBox::currentIndexChanged, this, &mainQT::erabu_pi);
    connect(ui->study_btn, &QPushButton::clicked, this, &mainQT::_study);
    connect(ui->set_btn, &QPushButton::clicked, this, &mainQT::_set);
    count_view();
    sagasu();
}

mainQT::~mainQT()
{
    delete ui;
}

void mainQT::sagasu(){
    ui->sagasu_list->clear();
    QString qkotoba = ui->kotoba_line->text();
    std::string kotoba = qkotoba.toStdString();
    list = search(kotoba);
    int l = list.size();
    for(int i = 0; i < l; i++){
        if (!(list[i].kanji.compare(list[i].kotoba))){
            QString kanji = QString::fromStdString(list[i].kanji);
            ui->sagasu_list->addItem(kanji);
        } else {
            QString kanji = QString::fromStdString(list[i].kanji);
            QString kotoba = QString::fromStdString(list[i].kotoba);
            QString q = kanji + "  " + kotoba;
            ui->sagasu_list->addItem(q);
        }
    }
    hisf = true;
}

void mainQT::imi_out(){
    ui->naiyou->setText("");
    cname = "";
    int n = ui->sagasu_list->currentRow();
    if (n<0){
        return;
    }
    QString kotoba = QString::fromStdString(list[n].kotoba);
    if (!(list[n].kotoba.compare(list[n].kanji))){
        ui->naiyou->append(kotoba);
    } else {
        QString kanji = QString::fromStdString(list[n].kanji);
        QString q = kanji + "  " + kotoba;
        ui->naiyou->append(q);
    }
    int h = list[n].hinsi;
    QString hinsi;
    switch(h){
    case 0:
        if(!loc.compare("ja_JP")){
            if(koutyakugo_f)
                hinsi = "[助詞]";
            else
                hinsi = "[前置詞]";
        } else if(!loc.compare("ko_KR")){
            if(koutyakugo_f)
                hinsi = "[조사]";
            else
                hinsi = "[전치사]";
        } else{
            if(koutyakugo_f)
                hinsi = "[Postposition]";
            else
                hinsi = "[Preposition]";
        }
       break;
    case 1:
        if(!loc.compare("ja_JP")){
            hinsi = "[名詞]";
        } else if(!loc.compare("ko_KR")){
            hinsi = "[명사]";
        } else{
            hinsi = "[Noun]";
        }
        break;
    case 2:
        if(!loc.compare("ja_JP")){
            hinsi = "[動詞]";
        } else if(!loc.compare("ko_KR")){
            hinsi = "[동사]";
        } else{
            hinsi = "[Verb]";
        }
        break;
    case 3:
        if(!loc.compare("ja_JP")){
            hinsi = "[形容詞]";
        } else if(!loc.compare("ko_KR")){
            hinsi = "[형용사]";
        } else{
            hinsi = "[Adjective]";
        }
        break;
    case 4:
        if(!loc.compare("ja_JP")){
            hinsi = "[副詞]";
        } else if(!loc.compare("ko_KR")){
            hinsi = "[부사]";
        } else{
            hinsi = "[Adverb]";
        }
        break;
    case 5:
        if(!loc.compare("ja_JP")){
            hinsi = "[その外]";
        } else if(!loc.compare("ko_KR")){
            hinsi = "[그 외]";
        } else{
            hinsi = "[Others]";
        }
        break;
    }
    ui->naiyou->append(hinsi);
    QString imi = QString::fromStdString(list[n].imi);
    QString bikou = QString::fromStdString(list[n].bikou);
    ui->naiyou->append(imi);
    ui->naiyou->append(bikou);
    static std::string t_kotoba = "";
    cname = list[n].kotoba;
    t_kotoba = list[n].kotoba;
}

void mainQT::count_view(){
    int *count_p = count_kotoba();
    count[0] = *count_p;
    for(int i = 1; i < 7; i++){
        count_p++;
        count[i] = *count_p;
    }
    ui->count_lcd->display(count[0]);
}

void mainQT::play_mp3(){
    if (!(cname.compare(""))) return;
    play_tts(cname);
}

void mainQT::_add(){
    bool k = false;
    add_ui = new add_kotoba(&k);
    add_ui->exec();
    delete add_ui;
    if (k){
        count_view();
        Pi();
        sagasu();
    }
}

void mainQT::_modify(){
    int n = ui->sagasu_list->currentRow();
    if (n<0){
        return;
    }
    bool k = false;
    modify_ui = new modify_kotoba(&list[n], &k);
    modify_ui->exec();
    delete modify_ui;
    if (k){
        ui->sagasu_list->clear();
        ui->naiyou->setText("");
        cname = "";
        sagasu();
    }
}

void mainQT::_del(){
    int n = ui->sagasu_list->currentRow();
    if (n<0){
        return;
    }
    QMessageBox::StandardButton f;
    if(!loc.compare("ja_JP")){
        f = QMessageBox::question(this, "警告", "本当に消してもいいですか？",
                                                              QMessageBox::Yes | QMessageBox::No);
    } else if(!loc.compare("ko_KR")){
        f = QMessageBox::question(this, "경고", "정말로 삭제 하겠습니까?",
                                                              QMessageBox::Yes | QMessageBox::No);
    } else{
        f = QMessageBox::question(this, "Warning", "Are you sure you want to delete this?",
                                                              QMessageBox::Yes | QMessageBox::No);
    }
    if (f == QMessageBox::No){
        return;
    }
    del_kotoba(list[n].kotoba);
    count_view();
    cname = "";
    Pi();
    ui->naiyou->setText("");
    sagasu();
}

void mainQT::Pi(){
    if (!hinsipi) {
            hinsipi = new QPieSeries();
    } else {
            hinsipi->clear();
    }
    std::string a;
    std::string b;
    std::string c;
    std::string d;
    std::string e;
    std::string f;

    if(!loc.compare("ja_JP")){
        if(koutyakugo_f)
            a = "助詞";
        else
            a = "前置詞";
        b = "名詞";
        c = "動詞";
        d = "形容詞";
        e = "副詞";
        f = "その外";
    } else if(!loc.compare("ko_KR")){
        if(koutyakugo_f)
            a = "조사";
        else
            a = "전치사";
        b = "명사";
        c = "동사";
        d = "형용사";
        e = "부사";
        f = "그 외";
    } else{
        if(koutyakugo_f)
            a = "Postposition";
        else
            a = "Preposition";
        b = "Noun";
        c = "Verb";
        d = "Adjective";
        e = "Adverb";
        f = "Others";
    }
    QPieSlice *s1 = hinsipi->append(QString::fromStdString(a), count[1]);
    s1->setBrush(Qt::yellow);
    QPieSlice *s2 = hinsipi->append(QString::fromStdString(b), count[2]);
    s2->setBrush(Qt::magenta);
    QPieSlice *s3 = hinsipi->append(QString::fromStdString(c), count[3]);
    s3->setBrush(Qt::cyan);
    QPieSlice *s4 = hinsipi->append(QString::fromStdString(d), count[4]);
    s4->setBrush(Qt::green);
    QPieSlice *s5 = hinsipi->append(QString::fromStdString(e), count[5]);
    s5->setBrush(Qt::lightGray);
    QPieSlice *s6 = hinsipi->append(QString::fromStdString(f), count[6]);
    s6->setBrush(Qt::gray);
    
    if (pi == nullptr) {
        pi = new QChart();
    }
    pi->addSeries(hinsipi);
    
    QPieSlice* slices[] = {s1, s2, s3, s4, s5, s6};
    for(int i = 0; i < 6; i++){
        if (count[0] > 0){
            slices[i]->setLabelFont(QFont("Noto Sans CJK JP", 7));
            slices[i]->setLabelVisible();
            slices[i]->setLabelColor(Qt::black);
        } else {
            slices[i]->setLabelVisible(false);
        }
    }
    
    pi->legend()->setVisible(false);
    update_chart_view();
    QString tmp;
    ui->naiyou->setText("");
    if(!loc.compare("ja_JP")){
        tmp += (koutyakugo_f ? "助詞 " : "前置詞 ") + QString::number(count[1]) + "\n";
        tmp += "名詞 " + QString::number(count[2]) + "\n";
        tmp += "動詞 " + QString::number(count[3]) + "\n";
        tmp += "形容詞 " + QString::number(count[4]) + "\n";
        tmp += "副詞 " + QString::number(count[5]) + "\n";
        tmp += "その外 " + QString::number(count[6]) + "\n";
    } else if(!loc.compare("ko_KR")){
        tmp += (koutyakugo_f ? "조사 " : "전치사 ") + QString::number(count[1]) + "\n";
        tmp += "명사 " + QString::number(count[2]) + "\n";
        tmp += "동사 " + QString::number(count[3]) + "\n";
        tmp += "형용사 " + QString::number(count[4]) + "\n";
        tmp += "부사 " + QString::number(count[5]) + "\n";
        tmp += "그 외 " + QString::number(count[6]) + "\n";
    } else{
        tmp += (koutyakugo_f ? "Postposition " : "Preposition ") + QString::number(count[1]) + "\n";
        tmp += "Noun " + QString::number(count[2]) + "\n";
        tmp += "Verb " + QString::number(count[3]) + "\n";
        tmp += "Adjective " + QString::number(count[4]) + "\n";
        tmp += "Adverb " + QString::number(count[5]) + "\n";
        tmp += "Others " + QString::number(count[6]) + "\n";
    }
    ui->naiyou->append(tmp);
}

void mainQT::update_chart_view(){
    if (!pi_view) {
        pi_view = new QChartView(pi);
        pi_view->setRenderHint(QPainter::Antialiasing);
        ui->layer->addWidget(pi_view);
    } else {
        pi_view->setChart(pi);
    }
}

void mainQT::rlsc(){
    int *count_p = get_study_pro();
    for(int i = 0; i < 3; i++){
        study_count[i] = *count_p;
        if(i < 2) count_p++;
    }
}

void mainQT::Pi2(){
    rlsc();
    if (!hinsipi) {
        hinsipi = new QPieSeries();
    } else {
        hinsipi->clear();
    }
    std::string d;
    std::string e;
    std::string f;
    if(!loc.compare("ja_JP")){
        d = "[覚えてない]";
        e = "[覚えている]";
        f = "[完璧に覚えている]";
    } else if(!loc.compare("ko_KR")){
        d = "[잘 모르는 단어]";
        e = "[알고 있는 단어]";
        f = "[완벽히 알고 있는 단어]";
    } else{
        d = "[not remember]";
        e = "[remember]";
        f = "[remember perfectly]";
    }
    QPieSlice *s1 = hinsipi->append(QString::fromStdString(d), study_count[0]);
    s1->setBrush(Qt::yellow);
    QPieSlice *s2 = hinsipi->append(QString::fromStdString(e), study_count[1]);
    s2->setBrush(Qt::magenta);
    QPieSlice *s3 = hinsipi->append(QString::fromStdString(f), study_count[2]);
    s3->setBrush(Qt::cyan);
    
    if (pi == nullptr) {
        pi = new QChart();
    }
    pi->addSeries(hinsipi);
    
    QPieSlice* slices[] = {s1, s2, s3};
    for(int i = 0; i < 3; i++){
        if (count[0] > 0){
            slices[i]->setLabelFont(QFont("Noto Sans CJK JP", 7));
            slices[i]->setLabelVisible();
            slices[i]->setLabelColor(Qt::black);
        } else {
            slices[i]->setLabelVisible(false);
        }
    }
    
    pi->legend()->setVisible(false);
    update_chart_view();
    
    QString tmp;
    ui->naiyou->setText("");
    if(!loc.compare("ja_JP")){
        tmp += "[覚えてない] " + QString::number(study_count[0]) + "\n";
        tmp += "[覚えている] " + QString::number(study_count[1]) + "\n";
        tmp += "[完璧に覚えている] " + QString::number(study_count[2]) + "\n";
    } else if(!loc.compare("ko_KR")){
        tmp += "[잘 모르는 단어] " + QString::number(study_count[0]) + "\n";
        tmp += "[알고 있는 단어] " + QString::number(study_count[1]) + "\n";
        tmp += "[완벽히 알고 있는 단어] " + QString::number(study_count[2]) + "\n";
    } else{
        tmp += "[not remember] " + QString::number(study_count[0]) + "\n";
        tmp += "[remember] " + QString::number(study_count[1]) + "\n";
        tmp += "[remember perfectly] " + QString::number(study_count[2]) + "\n";
    }
    ui->naiyou->append(tmp);
}

void mainQT::tab_henkou(){
    int t = ui->tab->currentIndex();
    if (t == 0){
        imi_out();
        ui->mp3_btn->setEnabled(true);
        ui->add_kotoba_btn->setEnabled(true);
        ui->modify_kotoba_btn->setEnabled(true);
        ui->del_kotoba_btn->setEnabled(true);
    } else {
        erabu_pi();
        ui->mp3_btn->setEnabled(false);
        ui->add_kotoba_btn->setEnabled(false);
        ui->modify_kotoba_btn->setEnabled(false);
        ui->del_kotoba_btn->setEnabled(false);
    }
}

void mainQT::erabu_pi(){
    int f = ui->sel_pi->currentIndex();
    if (f==0)
        Pi();
    else
        Pi2();
}

void mainQT::_study(){
    std::vector<tuple> sl = gen_study();
    study_ui = new study(sl);
    study_ui->exec();
    delete study_ui;
    erabu_pi();
}

void mainQT::_set(){
    init = new new_dic();
    init->exec();
    delete init;
}
