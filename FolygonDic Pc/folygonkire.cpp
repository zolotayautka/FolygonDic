#include "folygonkire.h"
#include <QProcess>
#include <QtGlobal>

const std::string path = (QDir::homePath() + "/Dictionary").toStdString();

static int callback(void *data, int argc, char **argv, char **azColName) {
    std::vector<tuple>* sagasu_list = static_cast<std::vector<tuple>*>(data);
    sagasu_list->push_back({argv[0], argv[1], argv[2], argv[3], std::stoi(argv[4]), std::stoi(argv[5])});
    return 0;
}

std::vector<tuple> search(std::string kotoba){
    std::vector<tuple> sagasu_list[5];
    std::ostringstream sql[4];
    sql[0] << "SELECT kotoba, imi, bikou, kanji, hinsi, count FROM dic WHERE kotoba LIKE '%" << kotoba << "%';";
    sql[1] << "SELECT kotoba, imi, bikou, kanji, hinsi, count FROM dic WHERE imi LIKE '%" << kotoba << "%';";
    sql[2] << "SELECT kotoba, imi, bikou, kanji, hinsi, count FROM dic WHERE kanji LIKE '%" << kotoba << "%';";
    sql[3] << "SELECT kotoba, imi, bikou, kanji, hinsi, count FROM dic WHERE bikou LIKE '%" << kotoba << "%';";
    sqlite3* db;
    sqlite3_open(path.c_str(), &db);
    for(int i = 0; i < 4; i++){
        sqlite3_exec(db, sql[i].str().c_str(), callback, &sagasu_list[i], nullptr);
    }
    sqlite3_close(db);
    std::set<tuple> tmp;
    for(int i = 0; i < 4; i++){
        tmp.insert(sagasu_list[i].begin(), sagasu_list[i].end());
    }
    sagasu_list[4].assign(tmp.begin(), tmp.end());
    return sagasu_list[4];
}

static int callback_count(void *data, int argc, char **argv, char **azColName) {
    int* count = static_cast<int*>(data);
    *count = std::stoi(argv[0]);
    return 0;
}

int* count_kotoba(){
    static int kotoba_count[7];
    const char* sql[] = {
        "SELECT count(kotoba) FROM dic;",
        "SELECT count(kotoba) FROM dic WHERE hinsi=0;",
        "SELECT count(kotoba) FROM dic WHERE hinsi=1;",
        "SELECT count(kotoba) FROM dic WHERE hinsi=2;",
        "SELECT count(kotoba) FROM dic WHERE hinsi=3;",
        "SELECT count(kotoba) FROM dic WHERE hinsi=4;",
        "SELECT count(kotoba) FROM dic WHERE hinsi=5;"
    };
    sqlite3* db;
    sqlite3_open(path.c_str(), &db);
    for(int i = 0; i < 7; i++){
        sqlite3_exec(db, sql[i], callback_count, &kotoba_count[i], 0);
    }
    sqlite3_close(db);
    return kotoba_count;
}

void play_tts(std::string kotoba){
    QString text = QString::fromStdString(kotoba);
    QString qlang = QString::fromStdString(load_lang());
    text.replace("'", "''");
#if defined(Q_OS_MAC)
    QString voice;
    if (!qlang.isEmpty()){
        if (qlang.startsWith("ja")) voice = "Kyoko";
        else if (qlang.startsWith("ko")) voice = "Yuna";
        else if (qlang.startsWith("zh")) voice = "Tingting";
        else if (qlang.startsWith("ru")) voice = "Milena";
        else if (qlang.startsWith("es")) voice = "Paulina";
        else if (qlang.startsWith("pt")) voice = "Luciana";
        else voice = "Samantha";
    }
    QStringList args;
    if (!voice.isEmpty()) args << "-v" << voice << text; else args << text;
    QProcess::startDetached("say", args);
#elif defined(Q_OS_WIN)
    QString winVoice;
    if (!qlang.isEmpty()){
        if (qlang.startsWith("ja")) winVoice = "Microsoft Haruka Desktop";
        else if (qlang.startsWith("ko")) winVoice = "Microsoft Heami Desktop";
        else if (qlang.startsWith("zh")) winVoice = "Microsoft Huihui Desktop";
        else if (qlang.startsWith("es")) winVoice = "Microsoft Helena Desktop";
        else if (qlang.startsWith("ru")) winVoice = "Microsoft Irina Desktop";
        else if (qlang.startsWith("pt")) winVoice = "Microsoft Maria Desktop";
        else winVoice = "Microsoft Zira Desktop";
    }
    QString escapedText = text;
    escapedText.replace("\"", "\"\"");
    QString psCommand;
    if (!winVoice.isEmpty()){
        psCommand = QString(
            "Add-Type -AssemblyName System.Speech; "
            "$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; "
            "try { $speak.SelectVoice('%1') } catch { }; "
            "$speak.Speak(\"%2\")"
        ).arg(winVoice, escapedText);
    } else {
        psCommand = QString(
            "Add-Type -AssemblyName System.Speech; "
            "$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; "
            "$speak.Speak(\"%1\")"
        ).arg(escapedText);
    }
    QProcess::startDetached("powershell", QStringList() << "-Command" << psCommand);
#else
    QString lang;
    if (!qlang.isEmpty()){
        if (qlang.startsWith("ja")) lang = "ja";
        else if (qlang.startsWith("ko")) lang = "ko";
        else if (qlang.startsWith("zh")) lang = "zh-CN";
        else if (qlang.startsWith("ru")) lang = "ru";
        else if (qlang.startsWith("es")) lang = "es";
        else if (qlang.startsWith("pt")) lang = "pt";
        else lang = "en";
    }
    QString command = QString("gtts-cli \"%1\" -l %2 -o - | mpg123 -q -")
        .arg(text, lang);
    QProcess::startDetached("sh", QStringList() << "-c" << command);
#endif
}

bool kaburu_check(std::string kotoba){
    int t;
    std::ostringstream sql;
    sql << "SELECT COUNT(*) FROM dic WHERE kotoba='" << kotoba << "';";
    sqlite3* db;
    sqlite3_open(path.c_str(), &db);
    sqlite3_exec(db, sql.str().c_str(), callback_count, &t, 0);
    sqlite3_close(db);
    if (t == 0){
        return false;
    } else {
        return true;
    }
}

bool add_kotoba_(tuple add_dic){
    if(kaburu_check(add_dic.kotoba)){
        return false;
    }
    std::ostringstream sql;
    sql << "INSERT INTO dic (kotoba, hinsi, imi, bikou, kanji) VALUES ('" << add_dic.kotoba << "', " << add_dic.hinsi << ", '" << add_dic.imi << "', '" << add_dic.bikou << "', '" << add_dic.kanji << "');";
    sqlite3* db;
    sqlite3_open(path.c_str(), &db);
    sqlite3_exec(db, sql.str().c_str(), 0, 0, 0);
    sqlite3_close(db);
    return true;
}

void modify_kotoba_(tuple t){
    std::ostringstream sql;
    sql << "UPDATE dic SET imi = '" << t.imi << "', bikou = '" << t.bikou << "', kanji = '" << t.kanji << "' WHERE kotoba='" << t.kotoba << "';";
    sqlite3* db;
    sqlite3_open(path.c_str(), &db);
    sqlite3_exec(db, sql.str().c_str(), 0, 0, 0);
    const char sql_[] = "VACUUM;";
    sqlite3_exec(db, sql_, 0, 0, 0);
    sqlite3_close(db);
}

void del_kotoba(std::string kotoba){
    std::ostringstream sql;
    sql << "DELETE FROM dic WHERE kotoba='" << kotoba << "';";
    sqlite3* db;
    sqlite3_open(path.c_str(), &db);
    sqlite3_exec(db, sql.str().c_str(), 0, 0, 0);
    const char sql_[] = "VACUUM;";
    sqlite3_exec(db, sql_, 0, 0, 0);
    sqlite3_close(db);
}

void create_dic(std::string lang, int kz){
    const char sql[] = "CREATE TABLE IF NOT EXISTS dic (\
                kotoba CHAR(20) PRIMARY KEY,\
                hinsi INT,\
                imi CHAR(80),\
                bikou CHAR(50),\
                kanji CHAR(20),\
                count INT DEFAULT 0\
            );\
            CREATE TABLE IF NOT EXISTS flag (\
                lang TEXT,\
                kazu INT\
            );";
    std::ostringstream sql4;
    sql4 << "INSERT INTO flag (lang, kazu) VALUES ('" << lang << "', " << kz << ");";
    sqlite3* db;
    sqlite3_open(path.c_str(), &db);
    sqlite3_exec(db, sql, 0, 0, 0);
    sqlite3_exec(db, sql4.str().c_str(), 0, 0, 0);
    sqlite3_close(db);
}

void update_set(std::string lang, int kz){
    std::ostringstream sql;
    sql << "UPDATE flag SET lang='" << lang << "', kazu=" << kz << ";";
    sqlite3* db;
    sqlite3_open(path.c_str(), &db);
    sqlite3_exec(db, sql.str().c_str(), 0, 0, 0);
    sqlite3_close(db);
}

static int lang_callback(void *data, int argc, char **argv, char **azColName) {
    std::string* lang = static_cast<std::string*>(data);
    *lang = argv[0];
    return 0;
}

bool koutyakugo(){
    if ((!load_lang().compare("ja-JP")) || (!load_lang().compare("ko-KR"))){
        return true;
    } else {
        return false;
    }
}

std::string load_lang(){
    const char sql[] = "SELECT lang FROM flag;";
    std::string lang;
    sqlite3* db;
    sqlite3_open(path.c_str(), &db);
    sqlite3_exec(db, sql, lang_callback, &lang, 0);
    sqlite3_close(db);
    return lang;
}

static std::vector<tuple> study_query(int limit, bool orderByCount, const std::vector<std::string>& exclude) {
    std::vector<tuple> result;
    std::ostringstream sql;
    std::string whereClause;
    if (!exclude.empty()) {
        whereClause = "WHERE kotoba NOT IN (";
        for (size_t i = 0; i < exclude.size(); ++i) {
            if (i) whereClause += ",";
            whereClause += "'" + exclude[i] + "'";
        }
        whereClause += ")";
    }
    std::string orderClause = orderByCount ? "ORDER BY count ASC, RANDOM()" : "ORDER BY RANDOM()";
    sql << "SELECT kotoba, imi, bikou, kanji, hinsi, count FROM dic " << whereClause << " " << orderClause << " LIMIT " << limit << ";";
    sqlite3* db;
    if (sqlite3_open(path.c_str(), &db) != SQLITE_OK) return result;
    sqlite3_exec(db, sql.str().c_str(), callback, &result, nullptr);
    sqlite3_close(db);
    return result;
}

static std::vector<tuple> study_sql(int n, int nx, bool sf = true) {
    std::vector<tuple> result;
    std::vector<tuple> first = study_query(n, sf, {});
    result.insert(result.end(), first.begin(), first.end());
    if (sf && nx > 0) {
        std::set<std::string> kotobaSet;
        for (auto &t : result) kotobaSet.insert(t.kotoba);
        int remaining = nx;
        while (remaining > 0) {
            std::vector<std::string> exclude(kotobaSet.begin(), kotobaSet.end());
            std::vector<tuple> temp = study_query(remaining, false, exclude);
            if (temp.empty()) break;
            std::vector<tuple> newlyAdded;
            for (auto &it : temp) {
                if (kotobaSet.find(it.kotoba) == kotobaSet.end()) {
                    newlyAdded.push_back(it);
                }
            }
            if (newlyAdded.empty()) break;
            for (auto &it : newlyAdded) {
                kotobaSet.insert(it.kotoba);
                result.push_back(it);
            }
            remaining -= (int)newlyAdded.size();
        }
    }
    return result;
}

std::vector<tuple> gen_study(){
    int desired = 0;
    sqlite3* db;
    if (sqlite3_open(path.c_str(), &db) != SQLITE_OK) return {};
    const char sql_kazu[] = "SELECT kazu FROM flag;";
    sqlite3_stmt* stmt = nullptr;
    if (sqlite3_prepare_v2(db, sql_kazu, -1, &stmt, nullptr) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            desired = sqlite3_column_int(stmt, 0);
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    if (desired <= 0) return {};
    int *counts = count_kotoba();
    int totalWords = counts[0];
    if (totalWords <= 0) return {};
    if (desired > totalWords) desired = totalWords;
    int nw = static_cast<int>(desired * 0.6);
    int od = desired - nw;
    std::vector<tuple> list = study_sql(nw, od);
    return list;
}

int* get_study_pro(){
    static int tmp[3] = {0, 0, 0};
    sqlite3* db;
    if (sqlite3_open(path.c_str(), &db) != SQLITE_OK) return tmp;
    const char* queries[3] = {
        "SELECT count(kotoba) FROM dic WHERE count=0;",
        "SELECT count(kotoba) FROM dic WHERE count=1;",
        "SELECT count(kotoba) FROM dic WHERE count>=2;"
    };
    sqlite3_stmt* stmt = nullptr;
    for (int i = 0; i < 3; ++i) {
        if (sqlite3_prepare_v2(db, queries[i], -1, &stmt, nullptr) == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                tmp[i] = sqlite3_column_int(stmt, 0);
            }
        }
        sqlite3_finalize(stmt);
    }
    sqlite3_close(db);
    return tmp;
}
    
void update_count(tuple up) {
    sqlite3* db = nullptr;
    if (sqlite3_open(path.c_str(), &db) != SQLITE_OK) return;
    const char* sql = "UPDATE dic SET count = ? WHERE kotoba = ?;";
    sqlite3_stmt* stmt = nullptr;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, nullptr) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, up.count);
        sqlite3_bind_text(stmt, 2, up.kotoba.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
}
