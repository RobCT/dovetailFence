#include "filereader.h"
#include <QFile>
#include <QStringBuilder>

FileReader::FileReader(QObject *parent)
	: QObject(parent)
{

}

void FileReader::setPinsTails(QList<QString> pins, QList<QString> tails) {
    for (int i = 0; i < pins.size(); ++i) {
	qDebug() << pins[i];
    }
    m_pins = pins;
    m_tails = tails;
}

void FileReader::savePinsTails() {
    QFile m_file(QStandardPaths::writableLocation (QStandardPaths::DocumentsLocation) + "/pinsntails.txt");
    if (m_file.open(QFile::WriteOnly | QFile::Truncate)) {
	QTextStream out(&m_file);
	out << "Pins:" << endl;
	for (int i = 0; i < m_pins.size(); ++i) {
	    out << m_pins[i] << endl;
	}
	out << "Tails:" << endl;
	for (int i = 0; i < m_tails.size(); ++i) {
	    out << m_tails[i] << endl;
	}
	out << "END" << endl;
	m_file.flush();
	m_file.close();
    }
}
void FileReader::readPinsTails() {
    QFile m_file(QStandardPaths::writableLocation (QStandardPaths::DownloadLocation) + "/pinsntails.txt");
    qDebug() << m_file.fileName();

    if (m_file.open(QFile::ReadOnly )) {
	QTextStream in(&m_file);
	m_pins.clear();
	m_tails.clear();
	in.readLineInto(&m_data);

	if (m_data == QString("Pins:")) {
	    while (m_data != QString("Tails:")) {
		in.readLineInto(&m_data);
		if (m_data != QString("Tails:"))
		    m_pins.append(m_data);
	    }
	    while (m_data != QString("END")) {
		in.readLineInto(&m_data);
		if (m_data != QString("END"))
		    m_tails.append(m_data);
	    }

	}
	for (int i = 0; i < m_pins.size(); ++i) {
	    qDebug() << m_pins[i];
	}
	for (int i = 0; i < m_tails.size(); ++i) {
	    qDebug() << m_tails[i];
	}

    }
}

QList<QString> FileReader::pins() const
{
    return m_pins;
}

QList<QString> FileReader::tails() const
{
    return m_tails;
}


