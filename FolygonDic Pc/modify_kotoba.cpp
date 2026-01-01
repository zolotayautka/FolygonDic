#include "modify_kotoba.h"
#include "ui_modify_kotoba.h"

modify_kotoba::modify_kotoba(tuple* t, bool* k, QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::modify_kotoba)
{
    ui->setupUi(this);
    setFixedSize(QSize(502, 372));
    this->t = t;
    ui->kotoba_line->setText(QString::fromStdString(t->kotoba));
    QString hinsi;
    if(!(!load_lang().compare("ja-JP") || !load_lang().compare("ko-KR") || !load_lang().compare("zh-CN") || !load_lang().compare("zh-TW"))){
        ui->kanji_line->hide();
        ui->label_2->hide();
        ui->imi_line->resize(QSize(431, 121));
        ui->bikou_line->resize(QSize(431, 111));
    }
    bool koutyakugo_f = koutyakugo();
    switch(t->hinsi){
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
    ui->cb->setText(hinsi);
    ui->imi_line->setText(QString::fromStdString(t->imi));
    ui->bikou_line->setText(QString::fromStdString(t->bikou));
    ui->kanji_line->setText(QString::fromStdString(t->kanji));
    this->k = k;
    connect(ui->modify_btn, &QPushButton::clicked, this, &modify_kotoba::_modify);
}

modify_kotoba::~modify_kotoba()
{
    delete ui;
}

void modify_kotoba::_modify(){
    t->imi = ui->imi_line->toPlainText().toStdString();
    t->bikou = ui->bikou_line->toPlainText().toStdString();
    t->kanji = ui->kanji_line->text().toStdString();
    modify_kotoba_(*t);
    *k = true;
}
