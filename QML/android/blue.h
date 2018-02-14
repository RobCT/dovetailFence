#ifndef BLUE_H
#define BLUE_H

#include <QObject>
#include <QString>
#include <QBluetoothSocket>
//#include <QBluetoothServiceInfo>
//#include <QBluetoothAddress>
//#include <QBluetoothUuid>


class Blue : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString msg READ msg)
public:
    explicit Blue(QObject *parent = 0);
    Q_INVOKABLE void openConnection();
    Q_INVOKABLE void socketConnected();
    Q_INVOKABLE void clientDisconnected();
    Q_INVOKABLE void readSocket();
    Q_INVOKABLE void sendMessage(QString msg);
    QString msg() const;
signals:
    void messageReceived();
    void clientConnected();
    void clientDis();

public slots:

private:
    QBluetoothSocket *m_socket;
    QByteArray m_line;
    QString m_msg;
};

#endif // BLUE_H
