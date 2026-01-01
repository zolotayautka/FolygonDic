#include "new_dic.h"
#include "ui_new_dic.h"
#include <QtWidgets/qlineedit.h>

new_dic::new_dic(bool* k, QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::new_dic)
{
    ui->setupUi(this);
    setFixedSize(QSize(320, 114));
    this->k = k;
    
    QLineEdit* lineEdit = ui->set_kazu->findChild<QLineEdit*>();
    if (lineEdit) {
        lineEdit->setReadOnly(true);
    }

    connect(ui->btn, &QPushButton::clicked, this, &new_dic::tukuru);
}

new_dic::new_dic(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::new_dic)
{
    ui->setupUi(this);
    setFixedSize(QSize(320, 114));
    this->new_f = false;
    
    QLineEdit* lineEdit = ui->set_kazu->findChild<QLineEdit*>();
    if (lineEdit) {
        lineEdit->setReadOnly(true);
    }

    connect(ui->btn, &QPushButton::clicked, this, &new_dic::tukuru);
}

new_dic::~new_dic()
{
    delete ui;
}

void new_dic::tukuru(){
    if (new_f){
        QString lang = ui->cb->currentText();
        int kz = ui->set_kazu->value();
        create_dic(lang.toStdString(), kz);
        *k = false;
    } else {
        QString lang = ui->cb->currentText();
        int kz = ui->set_kazu->value();
        update_set(lang.toStdString(), kz);
    }
    close();
}
