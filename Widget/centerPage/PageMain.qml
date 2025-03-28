import QtQuick.Controls
import QtQuick
import Widget
import Tiko
import ControlAPI

ScrollView {
    id: mainPage
    ScrollBar.horizontal.visible: false
    ScrollBar.vertical: TikoBarV {

    }

    Column {
        id: showColumn
        width: mainPage.width - 80
        spacing: 20
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 20

        Item {
            width: showColumn.width
            height: randMusicText.height + musicRandList.height + 10

            TikoTextLine {
                id: randMusicText
                exSize: 9
                opacity: 0.8
                width: parent.width
                text: qsTr("随机推荐歌曲")
            }

            ListView {
                id: musicRandList
                anchors.top: randMusicText.bottom
                anchors.topMargin: 6
                width: parent.width
                height: mainPage.height * 0.3
                orientation: ListView.Horizontal
                spacing: mainPage.height * 0.1

                model: ListModel {
                    id: musicRandModel
                }

                delegate: CoreMusicButton {
                    music: musicData
                    width: height
                    height: mainPage.height * 0.3
                }
            }
        }

        Item {
            width: showColumn.width
            height: alumbRandText.height + alumbRandList.height

            TikoTextLine {
                id: alumbRandText
                exSize: 9
                opacity: 0.7
                width: parent.width
                text: qsTr("随机推荐专辑")
            }

            ListView {
                id: alumbRandList
                anchors.top: alumbRandText.bottom
                anchors.topMargin: 6
                height: 150 + TikoSeit.fontPixelSize * 6
                width: parent.width
                orientation: ListView.Horizontal
                spacing: 10

                model: ListModel{
                    id: alumbRandModel
                }

                delegate: CoreAlumbButton {
                    alumb: alumbData
                }
            }
        }

        Item {
            width: showColumn.width
            height: artistRandText.height + artistRandList.height

            TikoTextLine {
                exSize: 9
                opacity: 0.7
                id: artistRandText
                width: parent.width
                text: qsTr("随机推荐歌手")
            }

            ListView {
                id: artistRandList
                anchors.top: artistRandText.bottom
                anchors.topMargin: 6
                height: 160
                width: parent.width
                orientation: ListView.Horizontal
                spacing: 10

                model: ListModel{
                    id: artistRandModel
                }

                delegate: CoreArtistButton {
                    artist: artistData
                }
            }
        }

    }

    function buildRand() {

        var alumbList = Core.getAlumbRandList()
        for (var i in alumbList) {
            alumbRandModel.append({alumbData: alumbList[i]})
        }

        var artistList = Core.getArtistRandList()
        for (i in artistList) {
            artistRandModel.append({artistData: artistList[i]})
        }

        var musicList = Core.getMusicRandList()
        for (i in musicList) {
            musicRandModel.append({musicData: musicList[i]})
        }
    }
}
