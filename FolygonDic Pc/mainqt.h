#ifndef MAINQT_H
#define MAINQT_H

#include <QMainWindow>
#include "folygonkire.h"
#include "add_kotoba.h"
#include "modify_kotoba.h"
#include <QtCharts/QChartView>
#include <QtCharts/QPieSeries>
#include <QtCharts/QChart>
#include <sys/stat.h>
#include <QMessageBox>
#include "new_dic.h"
#include "study.h"
#include <QLocale>

QT_BEGIN_NAMESPACE
namespace Ui { class mainQT; }
QT_END_NAMESPACE

class mainQT : public QMainWindow
{
    Q_OBJECT

public:
    mainQT(QWidget *parent = nullptr);
    ~mainQT();

private:
    Ui::mainQT *ui;
    add_kotoba* add_ui;
    modify_kotoba* modify_ui;
    study* study_ui;
    new_dic* init;
    int count[7];
    int study_count[3];
    std::vector<tuple> list;
    std::string cname = "";
    void count_view();
    QPieSeries *hinsipi = nullptr;
    QChart *pi = nullptr;
    QChartView *pi_view = nullptr;
    void Pi();
    void Pi2();
    void update_chart_view();
    bool koutyakugo_f;
    bool hisf = true;

private slots:
    void sagasu();
    void _add();
    void _modify();
    void _del();
    void imi_out();
    void play_mp3();
    void tab_henkou();
    void rlsc();
    void erabu_pi();
    void _study();
    void _set();
};

#endif // MAINQT_H
