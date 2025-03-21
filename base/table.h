#ifndef TABLE_H
#define TABLE_H

#include <QObject>
#include "music.h"

class Table : public QObject //播放列表
{
    Q_OBJECT
public:
    explicit Table(QObject *parent = nullptr);
    enum SORT_TYPE {
        SORT_TITTLE_ASC, SORT_TITTLE_DESC,
        SORT_ATRIST_ASC, SORT_ATRIST_DESC,
        SORT_ALUMB_ASC, SORT_ALUMB_DESC,
        SORT_NED_TIME_ASC, SORT_NED_TIME_DESC,
        SORT_LAST_EDIT_TIME_ASC, SORT_LAST_EDIT_TIME_DESC,
        SORT_LEVEL_ASC, SORT_LEVEL_DESC
    } sort;

    QString name;//列表名
    QString url;//文件夹路径
    QList<Music *> musics;//音乐库列表
    QList<Music *> showMusics;//显示音乐列表
    int tableId;//列表id
    bool isDir;

public:
    void copy(Table *a);

    //排序
    Q_INVOKABLE void sortMusic(int type);
    Q_INVOKABLE int getSort();

    //搜索
    Q_INVOKABLE void searchMusic(QString search);

    //得到最后id
    Q_INVOKABLE int getLastCoreId();

    //插入新音乐核心
    Q_INVOKABLE void insertMusic(Music *core);
    Q_INVOKABLE void insertMusic(QList<Music *> core);

    //移除音乐核心
    Q_INVOKABLE void removeMusic(int listId);

    //打开本地文件夹
    Q_INVOKABLE void openDir();

    //显示所有歌曲
    Q_INVOKABLE void showAllMusic();

    QString getName() const;
    void setName(const QString &newName);

    QList<Music *> getMusics() const;

    QList<Music *> getShowMusics() const;

signals:
    // 更新qml展示列表
    void updateMusic(int start, int length);

    // 删除数据
    void clearMusic();

    // 更新封面
    void updateCover();

    void nameChanged();

private:
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged FINAL)
    Q_PROPERTY(QList<Music *> showMusics READ getShowMusics CONSTANT)
    Q_PROPERTY(QList<Music *> musics READ getMusics CONSTANT)
};
#endif // TABLE_H
