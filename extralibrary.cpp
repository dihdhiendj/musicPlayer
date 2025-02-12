﻿#include "extralibrary.h"
#include "popupdata.h"
extern "C" {
#include "libavformat/avformat.h"
}

#include "taglib.h"
#include "fileref.h"
#include "tstring.h"
#include "audioproperties.h"

#include "fftw3.h"

#include <QPainter>
#include <QPainterPath>

/*
*设置文件参数
*/
bool ExtraLibrary::setMedia(QString url, QString title, QString artist, QString alumb, QString genre, QString year)
{
    PopupData* pop = PopupData::getInstance();
    TagLib::FileRef f(TagLib::String(url.toStdString(), TagLib::String::UTF8).toCWString());

    if(f.isNull()){
        pop->message(url + "打开文件失败");
        return false;
    }

    f.tag()->setTitle(TagLib::String(title.toStdString(), TagLib::String::UTF8));
    f.tag()->setArtist(TagLib::String(artist.toStdString(), TagLib::String::UTF8));
    f.tag()->setAlbum(TagLib::String(alumb.toStdString(), TagLib::String::UTF8));
    f.tag()->setYear(year.toInt());
    f.tag()->setGenre(TagLib::String(genre.toStdString(), TagLib::String::UTF8));

    if(!f.save()){
        pop->message(url + "保存文件失败");
        return false;
    }

    return true;
}

/*
*得到文件参数
*/
void ExtraLibrary::getMedia(Music* core)
{
    PopupData* pop = PopupData::getInstance();
    TagLib::FileRef f(TagLib::String(core->url.toStdString(), TagLib::String::UTF8).toCWString());
    if(f.isNull()){
        pop->message(core->url + "打开文件失败");
        return;
    }
    TagLib::Tag* t = f.tag();

    //读取信息
    core->title = QString::fromStdString(t->title().toCString(1));
    core->artist = QString::fromStdString(t->artist().toCString(1));
    core->alumb = QString::fromStdString(t->album().toCString(1));
    core->genre = QString::fromStdString(t->genre().toCString(1));
    core->year = QString::number(t->year());
    if(core->alumb == ""){
        core->alumb = core->title;
    }

    //读取已毫秒为时长
    TagLib::AudioProperties* audio = f.audioProperties();
    int64_t time = audio->lengthInMilliseconds();
    core->endTime = time;
}

/*
*从文件中提取图片
*/
QImage ExtraLibrary::loadIndexCover(QString musicUrl)
{
    QImage img;
    //从文件中读取封面
    AVFormatContext *fmt_ctx = NULL;
    if (avformat_open_input(&fmt_ctx, musicUrl.toUtf8(), NULL, NULL)){
        char errbuf[1024];
        av_strerror(AVERROR_UNKNOWN, errbuf, sizeof(errbuf));
    }
    for (unsigned int i = 0; i < fmt_ctx->nb_streams; i++){
        if (fmt_ctx->streams[i]->disposition & AV_DISPOSITION_ATTACHED_PIC){
            AVPacket pkt = fmt_ctx->streams[i]->attached_pic;
            //使用QImage读取完整图片数据
            img = QImage::fromData((uchar*)pkt.data, pkt.size);
            img = img.scaled(300, 300, Qt::KeepAspectRatioByExpanding);
        }
    }
    // 清理
    avformat_close_input(&fmt_ctx);

    return img;
}

QVector<double> ExtraLibrary::useFftw3(QVector<double> in, int N)
{
    QVector<double>out(N);
    // 创建一个FFTW计划（plan），它指定了如何计算DFT
    fftw_complex *in_ptr = reinterpret_cast<fftw_complex*>(fftw_malloc(sizeof(fftw_complex) * N));
    fftw_complex *out_ptr = reinterpret_cast<fftw_complex*>(fftw_malloc(sizeof(fftw_complex) * N));

    // 将std::vector数据复制到fftw_complex数组中
    for (int i = 0; i < N; ++i) {
        in_ptr[i][0] = in[i];
        in_ptr[i][1] = 0.0;
    }

    // 创建计划并计算DFT
    fftw_plan plan = fftw_plan_dft_1d(N, in_ptr, out_ptr, FFTW_FORWARD, FFTW_ESTIMATE);
    fftw_execute(plan);

    // 将结果从fftw_complex数组复制回std::vector
    for (int i = 0; i < N; ++i)
    {
        out[i] = sqrt(out_ptr[i][0]*out_ptr[i][0]+out_ptr[i][1]*out_ptr[i][1]);
    }

    // 清理
    fftw_destroy_plan(plan);
    fftw_free(in_ptr);
    fftw_free(out_ptr);
    return out;
}
