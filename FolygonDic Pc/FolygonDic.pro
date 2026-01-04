QT       += core gui charts

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    add_kotoba.cpp \
    folygondic.cpp \
    main.cpp \
    mainqt.cpp \
    modify_kotoba.cpp \
    new_dic.cpp \
    sqlite3.c \
    study.cpp

HEADERS += \
    add_kotoba.h \
    folygondic.h \
    mainqt.h \
    modify_kotoba.h \
    new_dic.h \
    sqlite3.h \
    study.h

FORMS += \
    add_kotoba.ui \
    mainqt.ui \
    modify_kotoba.ui \
    new_dic.ui \
    study.ui

TRANSLATIONS += \
    folygondic_ja.ts \
    folygondic_ko.ts \
    folygondic_en.ts

CONFIG += lrelease
CONFIG += embed_translations

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    resource.qrc

mac {
    ICON = icon.ico
}

win32 {
    RC_FILE = icon.rc
}
