#include <QtGui>
#include <QtQuick>
#include "qextserialport.h"
#include "filereader.h"
#include "serial.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<Serial>("org.qtproject.serial", 1, 0, "Serial");
    qmlRegisterType<FileReader>("org.qtproject.filereader", 1, 0, "FileReader");
    //QextSerialPort * port = new QextSerialPort();
    QQuickView view;
    app.setOrganizationName("RT Projects");
    app.setOrganizationDomain("rtp.com");
    app.setApplicationName("Dovetail Fence App");

    //view.engine()->addImportPath("/usr/share/qml/");
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl(QStringLiteral("qrc:/Views/main.qml")));
    view.show();

    return app.exec();


}

