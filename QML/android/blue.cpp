#include "blue.h"

Blue::Blue(QObject *parent)
    : QObject(parent)
{

}

void Blue::openConnection()
{
    static const QString serviceUuid(QStringLiteral("00001101-0000-1000-8000-00805F9B34FB"));
    m_socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol, this);
    m_socket->connectToService(QBluetoothAddress("98:D3:31:20:A2:45"), QBluetoothUuid(serviceUuid), QIODevice::ReadWrite);
    connect(m_socket, SIGNAL(connected()), this, SLOT(socketConnected()));
}

void Blue::socketConnected()
{
    qDebug() << "Connected";
    connect(m_socket, SIGNAL(readyRead()), this, SLOT(readSocket()));
    connect(m_socket, SIGNAL(disconnected()), this, SLOT(clientDisconnected()));
    emit clientConnected();


}

void Blue::readSocket()
{
    while (m_socket->canReadLine()) {
	QByteArray m_line = m_socket->readLine().trimmed();
	m_msg = QString(m_line);
	emit messageReceived();
    }
}
QString Blue::msg() const
{
    return m_msg;
}

void Blue::clientDisconnected()
{
    qDebug() << "Disconnected";
    emit clientDis();
}

void Blue::sendMessage(const QString msg)
{
    QByteArray m_sendmsg(msg.toStdString().c_str());
    m_socket->write(m_sendmsg);
    qDebug() << m_sendmsg;
}
