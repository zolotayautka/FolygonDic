#ifndef NEW_DIC_H
#define NEW_DIC_H

#include <QDialog>
#include "folygondic.h"

namespace Ui {
class new_dic;
}

class new_dic : public QDialog
{
    Q_OBJECT

public:
    explicit new_dic(bool* k, QWidget *parent = nullptr);
    explicit new_dic(QWidget *parent = nullptr);
    ~new_dic();

private:
    Ui::new_dic *ui;
    bool* k;
    bool new_f = true;

private slots:
    void tukuru();
};

#endif // NEW_DIC_H
