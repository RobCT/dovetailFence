TEMPLATE = app

QT += qml quick widgets bluetooth

SOURCES += main.cpp \
	blue.cpp \
	filereader.cpp

HEADERS += \
    blue.h \
    filereader.h

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

