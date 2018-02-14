#ifndef FILEREADER_H
#define FILEREADER_H

#include <QObject>
#include <QFileInfo>
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

    QList<QString> pins() const;
    QList<QString> tails() const;

Q_SIGNALS:


private slots:


private:
    void setSize(int value);
    QString m_data;

    QFile m_file;

    QList<QString> m_pins;
    QList<QString> m_tails;




};

#endif // FILEREADER_H
