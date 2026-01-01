/*******************************************************************************
 *
 * Copyright (C) 2024 Shin Sukju
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 ******************************************************************************/

#include "mainqt.h"
#include <QApplication>
#include <QLocale>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "folygonkire_cpp_" + QLocale(locale).name();
        if(!QLocale(locale).name().compare("ja_JP")){
            if (translator.load(":/folygonkire_cpp_ja.qm" + baseName)) {
                a.installTranslator(&translator);
                break;
            }
        } else if(!QLocale(locale).name().compare("ko_KR")){
            if (translator.load(":/folygonkire_cpp_ko.qm" + baseName)) {
                a.installTranslator(&translator);
                break;
            }
        } else{
            if (translator.load(":/folygonkire_cpp_en.qm" + baseName)) {
                a.installTranslator(&translator);
                break;
            }
        }
    }
    mainQT w;
    w.show();
    return a.exec();
}
