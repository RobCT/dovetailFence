#include "serial.h"


Serial::Serial(QObject *parent)
    : QObject(parent)
{

}


void Serial::getSerialDevice()
{
    QDir dir("/dev");
    filters << "ttyUSB*";
    dir.setFilter(QDir::System | QDir::Hidden );
    dir.setNameFilters(filters);
    devlist = dir.entryList();

    if (devlist.size() == 1) {
	s_dev = "/dev/" + devlist.at(0);
	this->openDevice();
    }

}

void Serial::openDevice()
{

    port = new QextSerialPort(s_dev.toLatin1(), QextSerialPort::EventDriven);
    connect(port, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
    port->setBaudRate(BAUD9600);
    port->setFlowControl(FLOW_OFF);
    port->setParity(PAR_NONE);
    port->setDataBits(DATA_8);
    port->setStopBits(STOP_1);
    if (port->open(QIODevice::ReadWrite) == true) {
	qDebug() << "listening for data on" << port->portName();
    }
    else {
	qDebug() << "device failed to open:" << port->errorString();
    }
}
void Serial::onReadyRead()
{

    QByteArray bytes = port->readLine();

    s_msg = QString(bytes);
    if (bytes.size() > 1)
	emit newmsg();

}
QString Serial::msg() const
{
    return s_msg;
}

void Serial::writeMsg(QString msg)
{
    QByteArray s_sendmsg(msg.toStdString().c_str());
    qDebug() << msg << s_sendmsg.size();

    if (port != NULL)
	{
	    port->write(s_sendmsg, s_sendmsg.size());
    }

}

void Serial::close() {
    {
	if (port != NULL)
	{
	    port->close();
	    delete port;
	    port = NULL;
	}
    }
}


