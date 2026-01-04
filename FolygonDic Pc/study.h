#ifndef STUDY_H
#define STUDY_H

#include <QDialog>
#include "folygondic.h"

namespace Ui {
class study;
}

class study : public QDialog
{
    Q_OBJECT

public:
    explicit study(std::vector<tuple> study_list, QWidget *parent = nullptr);
    ~study();

private slots:
    void toggle_meaning();
    void yes_ok();
    void no_ok();
    void _play();

private:
    Ui::study *ui;
    std::vector<tuple> slist;
    int cnt;
    int n;
    bool showText;
    
    void display_current();
    void next();
};

#endif // STUDY_H
