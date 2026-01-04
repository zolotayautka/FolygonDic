#ifndef MODIFY_KOTOBA_H
#define MODIFY_KOTOBA_H

#include <QDialog>
#include "folygondic.h"
#include <QFileDialog>
#include <QLocale>

namespace Ui {
class modify_kotoba;
}

class modify_kotoba : public QDialog
{
    Q_OBJECT

public:
    explicit modify_kotoba(tuple* t, bool* k, QWidget *parent = nullptr);
    ~modify_kotoba();

private:
    Ui::modify_kotoba *ui;
    tuple* t;
    bool* k;
    QLocale locale;
    QString loc = locale.name();

private slots:
    void _modify();
};

#endif // MODIFY_KOTOBA_H
