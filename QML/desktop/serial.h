#ifndef SERIAL_H
#define SERIAL_H

#include <QObject>
#include <QDir>
#include <QDebug>
#include <QStringList>
#include <QTimer>
#include <QBluetoothServer>
#include "qextserialport.h"


class Serial : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString msg READ msg)
public:
    explicit Serial(QObject *parent = 0);
    Q_INVOKABLE void getSerialDevice();
    Q_INVOKABLE void openDevice();
    Q_INVOKABLE void onReadyRead();
    Q_INVOKABLE void writeMsg(QString msg);
    Q_INVOKABLE void close();
    QString msg() const;

Q_SIGNALS:
    void newmsg();

public slots:

private:
    QDir dir;
    QStringList filters;
    QStringList devlist;
    QString s_dev;
    QString s_msg;
    QextSerialPort *port;
    QByteArray bytes;
    QByteArray s_sendmsg;
    QTimer timer;
    int a;


};

#endif // SERIAL_H
