#ifndef FOLYGONKIRE_H
#define FOLYGONKIRE_H

#include <iostream>
#include <vector>
#include <sstream>
#include <set>
#include <tuple>
#include <fstream>
#include <iomanip>
#include "sqlite3.h"
#include <QString>
#include <QDir>

struct tuple {
    std::string kotoba;
    std::string imi;
    std::string bikou;
    std::string kanji;
    int hinsi;
    int count;

    bool operator<(const tuple& other) const {
        return std::tie(kotoba, imi, bikou, kanji, hinsi, count) < std::tie(other.kotoba, other.imi, other.bikou, other.kanji, other.hinsi, other.count);
    }
};

std::vector<tuple> search(std::string kotoba);
int* count_kotoba();
bool add_kotoba_(tuple add_dic);
void modify_kotoba_(tuple t);
void del_kotoba(std::string kotoba);
void create_dic(std::string lang, int kz);
void update_set(std::string lang, int kz);
void play_tts(std::string kotoba);
std::vector<tuple> gen_study();
int* get_study_pro();
void update_count(tuple up);
bool koutyakugo();
std::string load_lang();

#endif // FOLYGONKIRE_H
