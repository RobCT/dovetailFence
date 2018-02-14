#ifndef FILEREADER_H
#define FILEREADER_H

#include <QObject>
#include <QFileInfo>
#include <QFileDialog>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QTemporaryFile>
#include <QDesktopServices>
#include <QFile>
#include <QDir>
#include <QDebug>
#include <QStandardPaths>
#include <QProcess>
#include <QList>
#include <QTextStream>
#include <QXmlStreamWriter>
#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QAndroidJniObject>
#endif
class FileReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QString> pins READ pins)
    Q_PROPERTY(QList<QString> tails READ tails)


public:
    explicit FileReader(QObject *parent = 0);

    Q_INVOKABLE void setPinsTails(QList<QString> pins, QList<QString> tails);
    Q_INVOKABLE void savePinsTails();
    Q_INVOKABLE void readPinsTails();
    Q_INVOKABLE void setSaveFileData(QList<QString> tool, QList<QString> material, QList<QString> pn, QList<QString> tl, QList<QString> process, QList<QString> haunch);
    Q_INVOKABLE void saveData(QString filename);
    Q_INVOKABLE QList<QString> readData(QString filename) ;
    QList<QString> pins() const;
    QList<QString> tails() const;

//#ifdef Q_OS_ANDROID

//#endif
Q_SIGNALS:


private slots:


private:

    QString m_data;
    QFile m_file;
    QFile s_file;
    QList<QString> m_pins;
    QList<QString> m_tails;
    QTextStream out;
    QXmlStreamWriter xout;
    QXmlStreamReader xin;
    QList<QString> s_tool;
    QList<QString> s_material;
    QList<QString> s_pins;
    QList<QString> s_tails;
    QList<QString> s_process;
    QList<QString> s_haunch;
    QList<QString> s_return;
    int inc;
    bool attr;


};

#endif // FILEREADER_H
