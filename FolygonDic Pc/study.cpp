#include "study.h"
#include "ui_study.h"

extern QLocale locale;
extern QString loc;

study::study(std::vector<tuple> study_list, QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::study)
    , slist(study_list)
    , cnt(0)
    , showText(false)
{
    ui->setupUi(this);
    setFixedSize(QSize(401, 300));
    ui->daimoku->setReadOnly(true);
    ui->see_mean->setReadOnly(true);
    if (slist.empty()) {
        close();
        return;
    }
    n = slist.size();
    display_current();
    connect(ui->see_mean_btn, &QPushButton::clicked, this, &study::toggle_meaning);
    connect(ui->yes_btn, &QPushButton::clicked, this, &study::yes_ok);
    connect(ui->no_btn, &QPushButton::clicked, this, &study::no_ok);
    connect(ui->play_tts_btn, &QPushButton::clicked, this, &study::_play);
    ui->see_mean->setVisible(false);
}

study::~study()
{
    delete ui;
}

void study::display_current() {
    if (cnt >= n) return;
    QString kanji = QString::fromStdString(slist[cnt].kanji);
    QString kotoba = QString::fromStdString(slist[cnt].kotoba);
    if (slist[cnt].kanji == slist[cnt].kotoba) {
        ui->daimoku->setText(kanji);
    } else {
        ui->daimoku->setText(kanji + "  " + kotoba);
    }
    QString imi = QString::fromStdString(slist[cnt].imi);
    QString bikou = QString::fromStdString(slist[cnt].bikou);
    ui->see_mean->setPlainText(imi + "\n" + bikou);
    ui->see_mean->setVisible(false);
    showText = false;
    if(!loc.compare("ja_JP")){
        ui->see_mean_btn->setText("[意味を見る]");
    } else if(!loc.compare("ko_KR")){
        ui->see_mean_btn->setText("[뜻 보기]");
    } else{
        ui->see_mean_btn->setText("[View Meaning]");
    }
}

void study::toggle_meaning() {
    showText = !showText;
    ui->see_mean->setVisible(showText);
    if (showText) {
        if(!loc.compare("ja_JP")){
            ui->see_mean_btn->setText("[意味を隠す]");
        } else if(!loc.compare("ko_KR")){
            ui->see_mean_btn->setText("[뜻 숨기기]");
        } else{
            ui->see_mean_btn->setText("[Hide Meaning]");
        }
    } else {
        if(!loc.compare("ja_JP")){
            ui->see_mean_btn->setText("[意味を見る]");
        } else if(!loc.compare("ko_KR")){
            ui->see_mean_btn->setText("[뜻 보기]");
        } else{
            ui->see_mean_btn->setText("[View Meaning]");
        }
    }
}

void study::yes_ok() {
    tuple tmp = slist[cnt];
    tmp.count = tmp.count + 1;
    update_count(tmp);
    next();
}

void study::no_ok() {
    tuple tmp = slist[cnt];
    if (tmp.count > 0) {
        tmp.count = 0;
    }
    update_count(tmp);
    next();
}

void study::_play() {
    play_tts(slist[cnt].kotoba);
}

void study::next() {
    if (cnt < n - 1) {
        cnt++;
        display_current();
    } else {
        close();
    }
}
