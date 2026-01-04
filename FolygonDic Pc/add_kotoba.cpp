#include "add_kotoba.h"
#include "ui_add_kotoba.h"

add_kotoba::add_kotoba(bool* k, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::add_kotoba)
{
    ui->setupUi(this);
    setFixedSize(QSize(502, 362));
    this->k = k;
    if(!(!load_lang().compare("ja-JP") || !load_lang().compare("ko-KR") || !load_lang().compare("zh-CN") || !load_lang().compare("zh-TW"))){
        ui->kanji_line->hide();
        ui->label_2->hide();
        ui->imi_line->resize(QSize(431, 121));
        ui->bikou_line->resize(QSize(431, 111));
    }
    bool koutyakugo_f = koutyakugo();
    if (!koutyakugo_f){
        if(!loc.compare("ja_JP")){
            ui->cb->setItemText(0, "前置詞");
        } else if(!loc.compare("ko_KR")){
            ui->cb->setItemText(0, "전치사");
        } else{
            ui->cb->setItemText(0, "Preposition");
        }
    }
    connect(ui->add_btn, &QPushButton::clicked, this, &add_kotoba::_add);
}

add_kotoba::~add_kotoba()
{
    delete ui;
}

void add_kotoba::_add(){
    tuple add_dic;
    QString kotoba = ui->kotoba_line->text();
    add_dic.kotoba = kotoba.toStdString();
    QString kanji = ui->kanji_line->text();
    if (!(kanji.compare(""))){
        add_dic.kanji = kotoba.toStdString();
    } else {
        add_dic.kanji = kanji.toStdString();
    }
    int hinsi = ui->cb->currentIndex();
    add_dic.hinsi = hinsi;
    QString imi = ui->imi_line->toPlainText();
    add_dic.imi = imi.toStdString();
    QString bikou = ui->bikou_line->toPlainText();
    add_dic.bikou = bikou.toStdString();
    bool f = add_kotoba_(add_dic);
    if (!f){
        if(!loc.compare("ja_JP")){
            QMessageBox::warning(nullptr, "お知らせ", "すでに存在することばです。");
        } else if(!loc.compare("ko_KR")){
            QMessageBox::warning(nullptr, "알림", "이미 존재하는 단어입니다.");
        } else{
            QMessageBox::warning(nullptr, "Notification.", "It's already an existing word.");
        }
    } else {
        *k = true;
    }
}

