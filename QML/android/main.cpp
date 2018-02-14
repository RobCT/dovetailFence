#include <QApplication>
#include <QtQuick>

#include <QQmlApplicationEngine>
#include "blue.h"
#include "filereader.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<Blue>("org.qtproject.mymodules", 1, 0, "Blue");
    qmlRegisterType<FileReader>("org.qtproject.filereader", 1, 0, "FileReader");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

