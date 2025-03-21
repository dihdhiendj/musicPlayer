#ifndef MUSICCORE_H
#define MUSICCORE_H

#include <QObject>
#include "base/music.h"
#include "base/table.h"
#include "base/alumb.h"
#include "base/artist.h"

class MusicCore : public QObject
{
    Q_OBJECT
public:
    static MusicCore* getInstance(){
        return instance;
    }

    static void buildInstance(){
        if(instance == nullptr){
            instance = new MusicCore;
        }
    }

    QList<Table *> tableList;       // 播放列表
    QList<Music *> musicList;       // 音乐核心列表
    QList<QList<Alumb *>> alumbLineList;      // 专辑列表
    QList<QList<Artist *>> artistLineList;     // 歌手列表

    QList<Music *> getMusicList() const;

    // 清楚数据
    void clearDate();

    // 写入列表,歌曲数据
    Q_INVOKABLE void writeJsonData();

    QJsonObject readJsonData();

    //获得音乐核心
    void getMusicCore(QList<Music *>musicList, QList<Table *> tableList, QList<QList<Artist *>> artistLineList, QList<QList<Alumb *>> alumbLineList);

    //新建播放列表
    Q_INVOKABLE void appendTable(QString tableName, bool isDir = false);

    //将歌曲移动到
    Q_INVOKABLE void tableMoveMusic(int orgTableId, int musicId, int aimTalbeId);


    QList<Table *> getTableList() const;

    QList<QList<Alumb *> > getAlumbLineList() const;

    QList<QList<Artist *> > getArtistLineList() const;

private:
    static MusicCore* instance;
    explicit MusicCore(QObject *parent = nullptr);

    Q_PROPERTY(QList<Table *> tableList READ getTableList CONSTANT)

    Q_PROPERTY(QList<Music *> musicList READ getMusicList CONSTANT)

    Q_PROPERTY(QList<QList<Alumb *> > alumbLineList READ getAlumbLineList CONSTANT FINAL)

    Q_PROPERTY(QList<QList<Artist *> > artistLineList READ getArtistLineList CONSTANT FINAL)

signals:
    // 列表增加
    void tableAdd();

    // 数据加载完成
    void finishInit();
};

#endif // MUSICCORE_H
