#ifndef MUSIC_H
#define MUSIC_H

#include "lrcdata.h"
#include "base/keyvaluepair.h"
#include <QObject>
#include <QFileInfo>

class Music : public QObject
{
    Q_OBJECT
public:
    QString title;
    QStringList artistList;
    QString url;
    QString album;
    QString lastEdit;
    long long endTime;
    qint64 lastEditTime;
    int coreId;
    int level;
    bool isLove;

    Music();

    //将数据写入文件
    Q_INVOKABLE void writeDataToFile(QStringList key, QStringList value);

    // 读取元数据
    void readMedia();

    // 读取所有标签
    Q_INVOKABLE QList<KeyValuePair *> getAllKey();

    //来自文件
    void fromFileInfo(QFileInfo info);

    //获得封面路径
    QString getCoverUrl();

    Q_INVOKABLE QString getLrcUrl();

    //获得歌词文件路径
    QList<LrcData *> getLyricsData();

    //获得父文件夹
    QString getParentDir();

    //获得文件基础名字
    QString getBaseName();

    //获得文件基础路径
    Q_INVOKABLE QString getBaseUrl();

    //获得时长
    Q_INVOKABLE QString getStringTime();

    //获得识别文本
    QString getKey();

    //加载封面
    QImage loadCover();

    //加载封面·
    QImage loadAloneCover();

    //判断是否符合搜索条件
    bool isSearch(QString aim);

    //得到lrc文件数据
    Q_INVOKABLE QString getLrcData();

    //获得搜索文本
    Q_INVOKABLE QString getSearchString();

    //复制音乐信息
    Q_INVOKABLE void copyMusicData();

    //复制音乐文件路径
    Q_INVOKABLE void copyMusicUrl();

    //打开音乐封面文件
    Q_INVOKABLE void openMusicDir();

    //打开音乐封面文件
    Q_INVOKABLE void openMusicCover();

    //打开音乐歌词文件
    Q_INVOKABLE void openMusicLrc();

    //格式转换
    Q_INVOKABLE void setSuffix(QString type);

    // 写入喜爱
    void writeLove();

    // 写入评级
    void writeLevel();

    QString getTitle() const;

    QString getArtist() const;

    QString getUrl() const;

    QString getAlbum() const;

    QString getLastEdit() const;

    int getCoreId() const;

    QString getGenre() const;

    QString getYear() const;

    bool getIsLove() const;
    void setIsLove(bool newIsLove);

    int getLevel() const;
    void setLevel(int newLevel);

    long long getEndTime() const;

signals:
    void isLoveChanged();

    void levelChanged();

private:
    Q_PROPERTY(QString title READ getTitle CONSTANT)
    Q_PROPERTY(QString artist READ getArtist CONSTANT)
    Q_PROPERTY(QString url READ getUrl CONSTANT)
    Q_PROPERTY(QString album READ getAlbum CONSTANT)
    Q_PROPERTY(QString lastEdit READ getLastEdit CONSTANT)
    Q_PROPERTY(int coreId READ getCoreId CONSTANT)
    Q_PROPERTY(bool isLove READ getIsLove WRITE setIsLove NOTIFY isLoveChanged FINAL)
    Q_PROPERTY(int level READ getLevel WRITE setLevel NOTIFY levelChanged FINAL)
    Q_PROPERTY(long long endTime READ getEndTime CONSTANT FINAL)
};

#endif // MUSIC_H
