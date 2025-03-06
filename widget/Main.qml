import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQml
import TikoAPI
import Tiko
import Widget

TikoFrameless{
    id: window
    width:Setting.windowRect.width
    minimumWidth: 800
    height:Setting.windowRect.height
    minimumHeight: 600
    x:Setting.windowRect.x
    y:Setting.windowRect.y
    visible: true
    title: qsTr("尘星音乐")

    Binding{
        target: TikoSeit
        property: "themeColor"
        value: Setting.themeColor
    }
    Binding{
        target: TikoSeit
        property: "transparentColor"
        value: Setting.transparentColor
    }
    Binding{
        target: TikoSeit
        property: "backdropColor"
        value: Setting.backdropColor
    }
    Binding{
        target: TikoSeit
        property: "fontFamily"
        value: Setting.mainFont.family
    }
    Binding{
        target: TikoSeit
        property: "fontPixelSize"
        value: Setting.mainFont.pixelSize
    }

    Component.onDestruction:{
        //写入配置
        var mousePos = centerView.mapToGlobal(0, 0)
        Setting.windowRect.width = window.width
        Setting.windowRect.height = window.height
        Setting.windowRect.x = mousePos.x
        Setting.windowRect.y = mousePos.y

        Setting.writeData()
    }

    StackView{
        id: centerView
        anchors.fill: parent

        PageMain{
            id:mainPage
            visible: false
        }

        Item{
            id: editPage
            visible: false

            ViewLeftBar{
                height: parent.height - bottomView.height
                width: 200
                id: barView
            }

            //中间内容导航
            ViewMain{
                id:mainView
                width: parent.width - barView.width
                height: barView.height
                anchors.left: barView.right
            }

            //底部导航
            ViewBottomBar{
                id: bottomView
                height: 90
                width: parent.width
                anchors.top: mainView.bottom
            }
        }

        initialItem: editPage
    }

    ViewPlayingTable {
        id: playingTable
        width: parent.width * 2 / 3
        height: parent.height - bottomView.height
        y:10
    }

    //对话框
    TikoPopupMessage{
        id: popupMessage
    }

    //计算长度
    TextMetrics{
        text: qsTr("00:00")
        font: Setting.mainFont
        onBoundingRectChanged: {
            CoreData.timeWidth = boundingRect.width
        }
    }
    TextMetrics{
        text: qsTr("00-00-00 00:00:0000")
        font: Setting.mainFont
        onBoundingRectChanged: {
            CoreData.editTimeWidth = boundingRect.width
        }
    }
    TextMetrics{
        text: qsTr("000000000")
        font: Setting.mainFont
        onBoundingRectChanged: {
            CoreData.playNumberWidth = boundingRect.width
        }
    }

    //切换到主页
    function stackMain(){
        if(centerView.currentItem != mainPage){
            centerView.pop(null)
            centerView.pushItem(mainPage)
            mainPage.show = true
        }
    }

    //切换到编辑页
    function stackCenter(){
        if(centerView.currentItem != editPage){
            mainPage.show = false
            centerView.pop(null)
            centerView.pushItem(editPage)
        }
    }

    //关联
    Connections{
        target: MediaPlayer

        function onCppAddDirTable(tableId){
            mainView.addPlayTablePage(tableId)
            barView.addDirTable(tableId)
        }

        function onCppAddUserTable(tableId){
            mainView.addPlayTablePage(tableId)
            barView.addUserTable(tableId)
        }
    }

    //关联
    Connections{
        target: Base

        function onSendMessage(text, type){
            TikoSeit.sendMessage(window, text, type)
        }
    }

    //清理数据
    function clearData(){
        barView.clearData()
        playingTable.clearData();
        mainView.clearData()
    }
}
