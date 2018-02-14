#include "filereader.h"
#include <QFile>
#include <QFileDialog>
#include <QStringBuilder>

FileReader::FileReader(QObject *parent)
	: QObject(parent)
{

}

void FileReader::setPinsTails(QList<QString> pins, QList<QString> tails) {
    //for (int i = 0; i < pins.size(); ++i) {
    //qDebug() << pins[i];
    //}
    m_pins = pins;
    m_tails = tails;
}

void FileReader::setSaveFileData(QList<QString> tool, QList<QString> material, QList<QString> pn, QList<QString> tl, QList<QString> process, QList<QString> haunch) {
    s_tool = tool;
    s_pins = pn;
    s_material = material;
    s_tails = tl;
    s_process = process;
    s_haunch = haunch;



}
QList<QString> FileReader::readData(QString filename)  {
    QFile s_file(filename);
    //qDebug() << filename;


    if (s_file.open(QFile::ReadOnly )) {
        inc = 0;
        attr = false;
        QXmlStreamReader xin(&s_file);
        while (!xin.atEnd()) {
                xin.readNext();
                if (xin.isStartElement()) {

                    if ((xin.name() != "setup") && (xin.name() != "tool") && (xin.name() != "material") && (xin.name() != "pins") && (xin.name() != "tails") && (xin.name() != "process") && (xin.name() != "haunches") ) {
                        s_return.append(xin.name().toString());
                        s_return.append(xin.attributes().value("value").toString());
                    }


                }



        }
        //qDebug() << s_return.size();
        return s_return;
    }
    return s_return;
}
void FileReader::saveData(QString filename) {
    QFile s_file(filename);


    if (s_file.open(QFile::WriteOnly | QFile::Truncate)) {
    QXmlStreamWriter xout(&s_file);
    xout.setAutoFormatting(true);
    xout.writeStartDocument();
    xout.writeStartElement("setup");
    xout.writeAttribute("version", "1.0");
    xout.writeStartElement("tool");
    for (int i = 0; i < s_tool.size(); ++i) {
        if (i % 2 == 0) {
          xout.writeEmptyElement(s_tool[i]);
        } else {
          xout.writeAttribute("value", s_tool[i]);
        }
    }
    xout.writeEndElement();
    xout.writeStartElement("material");
    for (int i = 0; i < s_material.size(); ++i) {
        if (i % 2 == 0 ) {
          xout.writeEmptyElement(s_material[i]);
        } else {
          xout.writeAttribute("value", s_material[i]);
        }
    }
    xout.writeEndElement();
    xout.writeStartElement("pins");
    for (int i = 0; i < s_pins.size(); ++i) {
        if (i % 2 == 0 ) {
          xout.writeEmptyElement(s_pins[i]);
        } else {
          xout.writeAttribute("value", s_pins[i]);
        }
    }
    xout.writeEndElement();
    xout.writeStartElement("tails");
    for (int i = 0; i < s_tails.size(); ++i) {
        if (i % 2 == 0 ) {
          xout.writeEmptyElement(s_tails[i]);
        } else {
          xout.writeAttribute("value", s_tails[i]);
        }
    }
    xout.writeEndElement();
    xout.writeStartElement("haunches");
    for (int i = 0; i < s_haunch.size(); ++i) {
        if (i % 2 == 0 ) {
          xout.writeEmptyElement(s_haunch[i]);
        } else {
          xout.writeAttribute("value", s_haunch[i]);
        }
    }
    xout.writeEndElement();
    xout.writeStartElement("process");
    for (int i = 0; i < s_process.size(); ++i) {
        if (i % 2 == 0 ) {
          xout.writeEmptyElement(s_process[i]);
        } else {
          xout.writeAttribute("value", s_process[i]);
        }
    }
    xout.writeEndElement();
    xout.writeEndElement();
    xout.writeEndDocument();
    s_file.flush();
    s_file.close();
    }
}

void FileReader::savePinsTails() {
    QFile m_file(QStandardPaths::writableLocation (QStandardPaths::DownloadLocation) + "/pinsntails.txt");
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
    //qDebug() << m_file.fileName();

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
    //for (int i = 0; i < m_pins.size(); ++i) {
        //qDebug() << m_pins[i];
    //}
    //for (int i = 0; i < m_tails.size(); ++i) {
        //qDebug() << m_tails[i];
    //}

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





