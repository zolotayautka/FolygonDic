#ifndef ADD_KOTOBA_H
#define ADD_KOTOBA_H

#include <QDialog>
#include "folygondic.h"
#include <QFileDialog>
#include <QMessageBox>
#include <QLocale>

namespace Ui {
class add_kotoba;
}

class add_kotoba : public QDialog
{
    Q_OBJECT

public:
    explicit add_kotoba(bool* k, QWidget *parent = nullptr);
    ~add_kotoba();

private:
    Ui::add_kotoba *ui;
    bool* k;
    QLocale locale;
    QString loc = locale.name();

private slots:
    void _add();
};

#endif // ADD_KOTOBA_H
