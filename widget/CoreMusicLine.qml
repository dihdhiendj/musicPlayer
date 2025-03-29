import QtQuick
import QtQuick.Layouts
import ControlAPI
import Tiko
import DataCore

Item {
    id: musicLine
    implicitHeight: 70
    implicitWidth: 100
    clip: true

    property var table
    property var alumb
    property var artist
    property int listId: 0
    property int type: 0
    property int musicId: music.coreId
    property MusicData music

    MouseArea{
        id: mouseArea
        onClicked:(mouse)=>{
            if(mouse.button === Qt.RightButton){
                CoreData.openMenuMusic(musicLine, music, 0)
            }
            else{
                musicLine.play()
            }
        }
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        hoverEnabled: true

        Row{
            x:10
            y:10
            width: parent.width - 20
            height: parent.height - 20
            spacing: 6

            //封面
            TikoImageAuto {
                id: cover
                width: 50
                height: 50
                normalUrl: "qrc:/image/music.png"
                loadUrl: "image://cover/file:" + musicLine.musicId.toString()
            }

            Column{
                id: coreName
                width: (parent.width - tool.width - cover.width - 30) / 2

                TikoTextLine{
                    text: musicLine.music.title
                    exSize: 3
                    font.bold: true
                    height: 30
                    width: parent.width
                }
                TikoTextLine{
                    text: musicLine.music.artist
                    height: 20
                    width: parent.width
                }
            }

            TikoTextLine{
                text: musicLine.music.alumb
                width: coreName.width
                height: 50
            }

            Row{
                id: tool
                spacing: 3

                Row {
                    id: hoverItem
                    width: 250
                    height: 50
                    spacing: 10

                    TikoButtonIcon{
                        text: qsTr("喜爱")
                        visible: mouseArea.containsMouse
                        width: 50
                        height: 50
                        onClicked: music.isLove = !music.isLove
                        icon.source: music.isLove ? "qrc:/image/love.png" : "qrc:/image/unlove.png"
                        useAutoColor: !music.isLove
                        cache: true
                    }

                    // 评级
                    Row{
                        width: 100
                        height: 50
                        spacing: 1
                        visible: mouseArea.containsMouse

                        Repeater{
                            delegate: TikoButtonIcon{
                                width: 20
                                height: 50
                                hover: 0
                                cache: true
                                onClicked: music.level = level
                                icon.source: music.level >= level ? "qrc:/image/int.png" : "qrc:/image/unInt.png"
                                useAutoColor: !(music.level >= level)
                            }
                            model: ListModel{
                                ListElement{level: 0}
                                ListElement{level: 1}
                                ListElement{level: 2}
                                ListElement{level: 3}
                                ListElement{level: 4}
                            }
                        }
                    }
                    TikoButtonIcon{
                        text: qsTr("更多")
                        visible: mouseArea.containsMouse
                        width: 50
                        height: 50
                        onClicked: CoreData.openMenuMusic(musicLine, music, 0)
                        icon.source: "qrc:/image/else.png"
                        cache: true
                    }
                }

                TikoTextLine{
                    text: musicLine.music.getStringTime()
                    width: CoreData.timeWidth
                    height: 50
                }
                TikoTextLine{
                    text: musicLine.music.lastEdit
                    width: CoreData.editTimeWidth
                    height: 50
                }
            }
        }
    }

    Rectangle{
        anchors.fill: parent
        radius: 5
        color: Setting.transparentColor//背景颜色
        opacity:{
            if(musicLine.listId % 2 === 1){
                opacity = 0.1
            }
            else{
                opacity = 0.05
            }
        }
    }

    function play(){
        switch(type){
        case -1:
            MediaPlayer.playMusic(table, listId)
            break
        case 0:
            MediaPlayer.playMusic(table, listId)
            break
        case 1:
            MediaPlayer.playMusic(alumb, listId)
            break
        case 2:
            MediaPlayer.playMusic(artist, listId)
            break
        }
    }
}
