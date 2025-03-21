import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects
import TikoAPI
import Tiko

Item {
    id: coreLrcLine
    height: 100

    property color playingColor: "#ffffffff"
    property color normalColor: "#80ffffff"
    property font lrcFont: Setting.mainLrcFont

    property var core
    property bool isUse: true
    property int lrcId: core.id
    property var startList: core.startList
    property var endList: core.endList
    property var textList: core.textList
    property var helpTextList: core.helpTextList
    property bool isPlay: MediaPlayer.playingLrc.id === lrcId

    MultiEffect {
        id: effct
        autoPaddingEnabled: true
        source: lrcShow
        anchors.fill: lrcShow
        blurEnabled: !isPlay
        blurMax: 30
        blur: 1.0
    }

    Canvas{
        id: lrcShow
        anchors.fill: coreLrcLine
        visible: false
        onPaint: {
            var ctx = getContext("2d")
            // 清除画布
            ctx.clearRect(0, 0, width, height);
            ctx.font = "bold "+ lrcFont.pixelSize.toString() +"px 'Microsoft YaHei', SimSun, sans-serif"
            var maxH = maxFontMetrics.boundingRect.height
            var lrc = coreLrcLine.textList
            var startX = 20
            var startY = maxH * 1.8
            var length = 0
            var overF = 0.0//超出当前字长
            var playingPos = MediaPlayer.player.position

            //计算主文本
            for(var i=0; i<lrc.length; i++){
                //计算字长
                oneFontMetrics.text = lrc[i]
                length = oneFontMetrics.advanceWidth + 3
                //达到长度底部
                if(startX + length > coreLrcLine.width - 20){//超出长度
                    startX = 20
                    startY += maxH
                }

                if(playingPos >= coreLrcLine.endList[i]){
                    overF = 1
                    ctx.fillStyle = coreLrcLine.playingColor;
                }
                else if(playingPos < coreLrcLine.startList[i]){
                    overF = 0
                    ctx.fillStyle = coreLrcLine.normalColor;
                }
                else{
                    overF = (playingPos - coreLrcLine.startList[i]) /
                            (coreLrcLine.endList[i] - coreLrcLine.startList[i])
                    overF = overF || 0
                    // 创建线性渐变（从左到右）
                    var gradient = ctx.createLinearGradient(startX, startY, startX + length - 3, startY);

                    // 添加颜色停止点（0~1 范围）
                    gradient.addColorStop(0, coreLrcLine.playingColor);
                    gradient.addColorStop(overF, coreLrcLine.playingColor);
                    gradient.addColorStop(overF, coreLrcLine.normalColor);
                    gradient.addColorStop(1, coreLrcLine.normalColor);

                    // 设置填充样式为渐变
                    ctx.fillStyle = gradient;
                }

                ctx.fillText(lrc[i], startX, startY - overF * 3)
                startX += length
            }

            //计算辅助文本
            ctx.fillStyle = coreLrcLine.normalColor;

            for (var j=0; j<helpTextList.length; j++){
                var text = helpTextList[j]
                startX = 20
                startY += maxH

                for(i=0; i<text.length; i++){
                    //计算字长
                    oneFontMetrics.text = text[i]
                    length = oneFontMetrics.advanceWidth + 3
                    //达到长度底部
                    if(startX + length > coreLrcLine.width - 20){//超出长度
                        startX = 20
                        startY += maxH
                    }
                    ctx.fillText(text[i], startX, startY - overF * 3)
                    startX += length
                }
            }
        }
    }

    onLrcFontChanged: lrcShow.requestPaint()
    onWidthChanged: setHeight()
    Component.onCompleted: {
        setHeight()
        lrcShow.requestPaint()
    }
    Connections{
        target: core
        function onUpdate(){
            lrcShow.requestPaint()
        }
    }


    Connections{
        target: MediaPlayer

        function onPlayingLrcIdChange(){
            if(isPlay != (MediaPlayer.playingLrc.id === lrcId)) {
                isPlay = (MediaPlayer.playingLrc.id === lrcId)
            }
        }
    }

    TextMetrics{
        id: oneFontMetrics
        font: coreLrcLine.lrcFont
    }

    TextMetrics{
        id: maxFontMetrics
        font: coreLrcLine.lrcFont
        text: "Y高"
    }

    MouseArea{
        anchors.fill: parent
        propagateComposedEvents: true
        acceptedButtons: Qt.RightButton | Qt.LeftButton

        onClicked:(mouse)=>{
                      //跳转到当前时间
                      if(mouse.button === Qt.LeftButton && isUse){
                          MediaPlayer.turnToLrc(coreLrcLine.lrcId)
                      }
                      mouse.accepted = false
                  }
    }

    function setHeight(){
        var startX = 20
        var length = 0
        var line = 1
        var lrc = coreLrcLine.textList

        for(var i=0; i<lrc.length; i++){
            //计算字长
            oneFontMetrics.text = lrc[i]
            length = oneFontMetrics.advanceWidth + 3
            if(startX + length >= coreLrcLine.width - 20){
                line++
                startX = 20
            }
            startX += length
        }

        for (var j=0; j<helpTextList.length; j++){
            var helpLine = helpTextList[j]
            startX = 20
            line++

            for(i=0; i<helpLine.length; i++){
                    //计算字长
                    oneFontMetrics.text = helpLine[i]
                    length = oneFontMetrics.advanceWidth + 3
                    if(startX + length >=  coreLrcLine.width - 20){
                        line++
                        startX = 20
                    }
                    startX += length
            }
        }

        coreLrcLine.height = (line + 1.6) * maxFontMetrics.boundingRect.height
    }
}

